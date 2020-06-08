import 'dart:io';
import 'package:yourpage/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yourpage/models/post.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Uploader.dart';

class NewPost extends StatefulWidget {
  final uid;

  NewPost({
    Key key,
    @required this.uid,
  }) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  List<File> _imageFile = new List();
  int _imageSelected = 0;
  bool upload = false;
  String title;
  String caption;
  String country;
  String city;
  final _formKey = GlobalKey<FormState>();
  Post post;
  bool _isUploading = false;

  Widget _buildTitle() {
    return TextFormField(
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          hintText: 'my trip to mars',
          labelText: 'title',
          labelStyle: TextStyle(color: Colors.purple)),
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'The title is the most important part!';
        }
        if (value.length > 30) {
          return 'The title is too long';
        }
      },
      onSaved: (String value) {
        title = value;
      },
    );
  }

  Widget _buildCaption() {
    return TextFormField(
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          hintText: 'I forgot the oxygen',
          labelText: 'caption',
          labelStyle: TextStyle(color: Colors.purple)),
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'What\'s a post without a caption?';
        }
        if (value.length > 200) {
          return 'The caption is too long';
        }
      },
      onSaved: (String value) {
        caption = value;
      },
    );
  }

  Widget _buildCountry() {
    return new DropdownButtonFormField<String>(
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          labelText: 'Select a country',
          labelStyle: TextStyle(color: Colors.purple)),
      items: <String>['Spain', 'United States', 'England', 'Norway']
          .map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      value: country,
      // ignore: missing_return
      /*validator: (String value) {
        if (value.isEmpty) {
          return 'select a country';
        }
      },*/
      onSaved: (String value) {
        country = value;
      },
      onChanged: (String value) {
        setState(() => country = value);
      },
    );
  }

  Widget _buildCity() {
    return TextFormField(
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          hintText: 'Where are these pictures?',
          labelText: 'City',
          labelStyle: TextStyle(color: Colors.purple)),
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'Where was this?';
        }
        if (value.length > 15) {
          return 'City is too long';
        }
      },
      onSaved: (String value) {
        city = value;
      },
    );
  }

  void _newPost() {
    setState(() {
      _isUploading = true;
    });
    Post post = new Post(widget.uid, country, city, title, caption);
    FirestoreService().createPost(widget.uid, post).then((document) => {
          _startUpload(document.documentID).then((imageUrls) => {}),
        });
//    setState(() => post = new Post(widget.uid, country, city, title, caption));
  }

  // UPLOAD IMAGES
  StorageUploadTask _uploadTask;
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: storageRef);
  final storagePath = '/images/posts/';

  Future _startUpload(String postId) async {
    String filePath;
    StorageTaskSnapshot storageTaskSnapshot;
    _imageFile.asMap().forEach((int index, file) async => {
          filePath = 'users/${widget.uid}$storagePath$postId/$index',
          setState(() {
            _uploadTask = _storage.ref().child(filePath).putFile(file);
          }),
          storageTaskSnapshot = await _uploadTask.onComplete,
          await storageTaskSnapshot.ref.getDownloadURL().then((imageUrl) => {
                FirestoreService()
                    .addPostImages(widget.uid, postId, imageUrl)
                    .whenComplete(() => {
                          if (index == _imageFile.length - 1)
                            {Navigator.pop(context)}
                        }),
              }),
        });
  }

  void _default() {
    setState(() => {
          _isUploading = false,
          _imageFile = new List(),
          title = '',
          caption = '',
          country = '',
          city = '',
        });
  }

  // IMAGES
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile.add(selected);
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile[_imageSelected].path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Edit image',
        toolbarColor: Colors.black,
        statusBarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        backgroundColor: Colors.black,
        activeControlsWidgetColor: Colors.purple,
      ),
    );

    setState(() {
      _imageFile[_imageSelected] = cropped ?? _imageFile[_imageSelected];
    });
  }

  void selectImage(int position) {
    setState(() => _imageSelected = position);
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('New post'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: Scaffold(
                backgroundColor: Colors.black,
//      body: _imageFile != null
                body: _imageFile != null && _imageFile.length > 0
                    ? CustomScrollView(
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 100.0,
                              mainAxisSpacing: 0.0,
                              crossAxisSpacing: 0.0,
                              childAspectRatio: 0.75,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => selectImage(index),
                                child: Container(
                                  color: _imageSelected == index
                                      ? Colors.purple
                                      : null,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      top: 4.0,
                                      left: 4.0,
                                      right: 4.0,
                                      bottom: 4.0),
                                  child: Column(
                                    children: <Widget>[
                                      Image.file(_imageFile[index]),
                                    ],
                                  ),
                                ),
                              );
                            }, childCount: _imageFile.length),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Icon(
                                          Icons.crop,
                                          color: Colors.white,
                                        ),
                                        onPressed: _cropImage,
                                      ),
                                      FlatButton(
                                        child: Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                        ),
                                        onPressed: _clear,
                                      ),
                                    ],
                                  ),
                                  Uploader(
                                    file: _imageFile,
                                    uid: widget.uid,
//                                post: widget.post,
                                  ),
                                ],
                              );
                            }, childCount: 1),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'upload images*',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          ],
                        ),
                      ),
                bottomNavigationBar: BottomAppBar(
                  color: Colors.white10,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.photo_camera),
                        color: Colors.white,
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        color: Colors.white,
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                ),
              ),
            ),
//            Container(height: 300, child: UploadImagesView(widget.uid, post)),
            // FORM
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildTitle(),
                    _buildCaption(),
                    _buildCountry(),
                    _buildCity(),
                    RaisedButton(
                      color: Colors.purple,
                      child: Text(
                        _isUploading ? 'Uploading...' : 'Post',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _isUploading
                          ? null
                          : () {
                              if (!_formKey.currentState.validate() ||
                                  _imageFile.length == 0) {
                                print('not validated');
                                return;
                              }
                              _formKey.currentState.save();
                              _newPost();
                            },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
