import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/components/posts_components/post_card.dart';
import 'package:yourpage/models/comment.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class UserPosts extends StatefulWidget {
  final user;

  UserPosts(this.user);

  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  List _latestPosts = new List();
  String uid;
  bool _showLoader = true;
  int _postsListLength = 0;
  bool _isLastPost = false;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();

  _getPosts() {
    bool found = false;
//    _showLoader = true;
    FirestoreService()
        .getUserPosts(widget.user, _lastDocument)
        .snapshots()
        .listen((querySnapshot) => {
              querySnapshot.documents.forEach((newPost) => {
                    _latestPosts.asMap().forEach((index, post) => {
                          if (_latestPosts[index]['postId'] ==
                              newPost.data['postId'])
                            {
                              _latestPosts[index] = newPost.data,
                              found = true,
                            }
                        }),
                    if (!found)
                      {
                        _latestPosts.add(newPost.data),
                        _postsListLength = _postsListLength + 1,
                      },
                  }),
//              if (_postsListLength == _latestPosts.length)
              if (_postsListLength > 0 && _showLoader)
                {
                  setState(() {
                    _showLoader = false;
                  })
                }
            });
  }

  @override
  void initState() {
    _getPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_showLoader &&
          !_isLastPost) {
        _getPosts();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.uid = Provider.of<String>(context);
    return _showLoader
        ? Loader()
        : !_showLoader && _latestPosts.length == 0
            ? Text(
                'no posts',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
              controller: _scrollController,
              itemCount: _latestPosts.length,
              itemBuilder: ((context, index) {
                return Container(
                  padding: EdgeInsets.only(bottom: 100),
                  child: PostCard(_latestPosts[1], widget.user, index),
                );
              }),
            );
  }
}
/*
Expanded(
child: CustomScrollView(
controller: _scrollController,
slivers: <Widget>[
SliverAppBar(
title: Text('Posts'),
),
SliverList(
delegate: SliverChildBuilderDelegate((context, index) {
return Container(
padding: EdgeInsets.only(bottom: 20),
child:
PostCard(_latestPosts[index], widget.user, index),
);
}, childCount: _latestPosts.length),
)
],
),
);*/
