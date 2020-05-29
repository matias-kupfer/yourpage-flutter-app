import 'package:flutter/material.dart';

import 'comment_card.dart';

class Comments extends StatelessWidget {
  final post;

  Comments(this.post);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: post['comments'].length,
      itemBuilder: (context, index) {
        return CommentCard(post['comments'][index]);
      },
    );
  }
}
