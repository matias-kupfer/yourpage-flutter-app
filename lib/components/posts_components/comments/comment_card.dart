import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class CommentCard extends StatelessWidget {
  final comment;

  CommentCard(this.comment);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreService()
            .getUserByUsername(comment['commentUsername'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var commentUser = snapshot.data.documents[0];
            return Row(
              children: <Widget>[
                Image.network(
                  commentUser['accountInfo']['imageUrl'],
                  width: 25,
                  height: 25,
                ),
                Text(
                  comment['content'],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  comment['date'].seconds != null
                      ? DateFormat('dd-MM-yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              comment['date'].seconds * 1000))
                      : comment['date'],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            );
          } else {
            return Loader();
          }
        });
  }
}
