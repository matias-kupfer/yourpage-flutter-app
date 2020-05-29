import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yourpage/models/post.dart';

import 'Uploader.dart';

class UploadImagesView extends StatefulWidget {
  final String uid;
  final Post post;

  UploadImagesView(this.uid, this.post);

  @override
  _UploadImagesViewState createState() => _UploadImagesViewState();
}

class _UploadImagesViewState extends State<UploadImagesView> {
  List<File> _imageFile = new List();
  int _imageSelected = 0;

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
//      body: _imageFile != null
      body: _imageFile != null && _imageFile.length > 0
          ? CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
                        color: _imageSelected == index ? Colors.purple : null,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            top: 4.0, left: 4.0, right: 4.0, bottom: 4.0),
                        child: Image.file(_imageFile[index]),
                      ),
                    );
                  }, childCount: _imageFile.length),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Container(
                            height: 300,
                            child: Image.file(_imageFile[_imageSelected])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          post: widget.post,
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
                    'upload image/s',
                    style: TextStyle(color: Colors.white, fontSize: 40),
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
    );
  }
}
