import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final answers = [];
  final commentUsername;
  final content;
  final date = new DateTime.now();

//  final date = FieldValue.serverTimestamp();
  final liked = false;

  Comment(this.commentUsername, this.content);

  toMap() {
    return {
      'answers': [],
      'commentUsername': commentUsername,
      'content': content,
      'date': date,
      'liked': liked,
    };
  }
}
