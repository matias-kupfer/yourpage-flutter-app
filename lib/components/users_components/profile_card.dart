import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/components/users_components/user_card.dart';
import 'package:yourpage/pages/profile/posts_components/user_posts.dart';

class ProfileCard extends StatefulWidget {
  final DocumentSnapshot user;

  ProfileCard(this.user);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    var uid = Provider.of<String>(context);
    return Column(
      children: <Widget>[
        UserCard(widget.user),
        UserPosts(widget.user),
      ],
    );
  }
}
