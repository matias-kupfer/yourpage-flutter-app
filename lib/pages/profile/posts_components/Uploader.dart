import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yourpage/models/post.dart';

// ignore: must_be_immutable
class Uploader extends StatefulWidget {
  List<File> file;
  final uid;
  final Post post;

  Uploader({Key key, this.file, this.uid, this.post}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://yourpage-4e4b4.appspot.com');

  StorageUploadTask _uploadTask;

  /*Future<void> _startUpload(String uid) async {
    var uid = widget.uid;
    String filePath;
    StorageTaskSnapshot storageTaskSnapshot;
    widget.file.asMap().forEach((int index, file) async => {
          filePath = 'images/$index.png',
          setState(() {
            _uploadTask = _storage.ref().child(filePath).putFile(file);
          }),
          storageTaskSnapshot = await _uploadTask.onComplete,
//          userData.imageUrl = await storageTaskSnapshot.ref.getDownloadURL(),
//          FirestoreService().updateUser(userData),
        });
  }*/

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;
            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            return Column(
              children: [
                if (_uploadTask.isComplete) Text('uploaded!'),
                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: _uploadTask.resume,
                  ),
                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(
                      Icons.pause,
                      color: Colors.white,
                    ),
                    onPressed: _uploadTask.pause,
                  ),
                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return Text('');
      /*return FlatButton.icon(
        label: Text('Upload', style: TextStyle(color: Colors.white)),
        icon: Icon(
          Icons.cloud_upload,
          color: Colors.teal,
        ),
        onPressed: null,
      );*/
    }
  }
}
