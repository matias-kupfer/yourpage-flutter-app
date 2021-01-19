import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/components/posts_components/post_card.dart';
import 'package:yourpage/components/users_components/user_card.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/constants.dart';
import 'package:yourpage/shared/loader.dart';

class ProfileCard extends StatefulWidget {
  final DocumentSnapshot user;
  final bool showAppBar;

  ProfileCard(this.user, this.showAppBar);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
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
              setState(() {
                _showLoader = false;
              })
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
    return !_showLoader
        ? CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              /*SliverAppBar(
                    title: Text('@' + widget.user['accountInfo']['userName']),
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: UserCard(widget.user),
                    ),
                    expandedHeight: 300,
                  ),*/
              if (widget.showAppBar) ...[
                SliverAppBar(
                  title: Text('@' + widget.user['accountInfo']['userName']),
                  floating: true,
                  backgroundColor: darkGray,
                )
              ],
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: <Widget>[
                        index == 0 ? UserCard(uid, widget.user) : Container(),
                        _latestPosts.length == 0
                            ? Text(
                                'USER HAS NO POSTS',
                                style: TextStyle(color: Colors.white),
                              )
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                                child: Container(
                                  child: PostCard(
                                      _latestPosts[index], widget.user, index),
                                ),
                              ),
                      ],
                    ),
                  );
                },
                    childCount:
                        _latestPosts.length == 0 ? 1 : _latestPosts.length),
              )
            ],
          )
        : Loader();
  }
}
