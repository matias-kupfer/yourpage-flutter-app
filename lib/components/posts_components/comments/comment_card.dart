import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/constants.dart';
import 'package:yourpage/shared/loader.dart';

class CommentCard extends StatelessWidget {
  final comment;
  final position;
  final updatePost;
  final isUserPost;

  CommentCard(this.comment, this.position, this.updatePost, this.isUserPost);

  Widget _likedComment() {
    if (comment['liked']) {
      return IconButton(
        icon: Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        onPressed: () => updatePost(position),
      );
    } else if (isUserPost) {
      return IconButton(
        icon: Icon(
          Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () => updatePost(position),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreService()
            .getUserByUsername(comment['commentUsername'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var commentUser = snapshot.data.documents[0];
            return ListTile(
              contentPadding: EdgeInsets.only(
                left: 5,
                right: 5,
                top: 0,
                bottom: 0,
              ),
              /*
              * GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/profile',
                            arguments: postUser['accountInfo']['userName']),
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundImage:
                              NetworkImage(postUser['accountInfo']['imageUrl']),
                        ),
                      ),*/
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/profile',
                    arguments: commentUser['accountInfo']['userName']),
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage:
                      NetworkImage(commentUser['accountInfo']['imageUrl']),
                ),
              ),
              title: Align(
                child: RichText(
                  text: TextSpan(children: [
                    new TextSpan(
                        text: '@' + comment['commentUsername'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    new TextSpan(
                        text: ' ' + comment['content'],
                        style: TextStyle(color: lightGray)),
                  ]),
                ),
//                alignment: Alignment(-1.5, 0),
                alignment: Alignment.bottomLeft,
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _likedComment(),
                  Text(
                    DateFormat('dd-MM-yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            comment['date'].seconds * 1000)),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
//                alignment: Alignment.centerRight,
            );
          } else {
            return Loader();
          }
        });
  }
}
