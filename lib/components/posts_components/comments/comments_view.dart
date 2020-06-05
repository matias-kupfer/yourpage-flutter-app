import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/services/firestore.dart';

import 'comment_card.dart';

class Comments extends StatelessWidget {
  final post;
  var uid;

  Comments(this.post);

  _updatePost(int position) {
    if (uid != post['userId']) {
      return;
    }
    post['comments'][position]['liked'] = !post['comments'][position]['liked'];
    FirestoreService().updatePost(post);
  }

  @override
  Widget build(BuildContext context) {
    this.uid = Provider.of<String>(context);
    return ListView.builder(
      padding: EdgeInsets.only(left: 5, right: 5),
      itemCount: post['comments'].length,
      itemBuilder: (context, index) {
        return CommentCard(
            post['comments'][index], index, _updatePost, uid == post['userId']);
      },
    );
  }
}
