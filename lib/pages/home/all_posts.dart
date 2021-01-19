import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/components/posts_components/post_card.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  var user;
  List _latestPosts = new List();
  String uid;
  bool _showLoader = true;
  int _postsListLength = 0;
  bool _isLastPost = false;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();

  _getLatestPostsInfo() {
//    _showLoader = false;
    FirestoreService()
        .getLatestPostsInfo(_lastDocument)
        .then((QuerySnapshot res) => {
              res.documents.length == 0
                  ? setState(() {
                      _isLastPost = true;
                      _showLoader = false;
                    })
                  : _postsListLength = _postsListLength + res.documents.length,
              _lastDocument = res.documents[res.documents.length - 1],
              res.documents.forEach(_getLatestPosts)
            })
        .catchError((error) => print(error));
  }

  _getLatestPosts(DocumentSnapshot postInfo) {
    bool found = false;
    FirestoreService()
        .getPost(postInfo.data)
        .snapshots()
        .listen((querySnapshot) => {
              _latestPosts.asMap().forEach((index, post) => {
                    if (_latestPosts[index]['postId'] ==
                        querySnapshot.data['postId'])
                      {
                        _latestPosts[index] = querySnapshot.data,
                        found = true,
                      }
                  }),
              if (!found)
                {
                  _latestPosts.add(querySnapshot.data),
                },
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
    _getLatestPostsInfo();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_showLoader &&
          !_isLastPost) {
        _getLatestPostsInfo();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.uid = Provider.of<String>(context);
    return StreamBuilder(
        stream: FirestoreService().getUserById(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            this.user = snapshot.data;
            return _showLoader
                ? Loader()
                : !_showLoader && _latestPosts.length == 0
                    ? Text(
                        'no posts',
                        style: TextStyle(color: Colors.white),
                      )
                    : CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          /*SliverAppBar(
                            expandedHeight: 150,
                            flexibleSpace: FlexibleSpaceBar(
                              title: Text('ALL POSTS'),
                            ),
                          ),*/
                          SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return index == _latestPosts.length - 1
                                  ? Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                                    child: Container(
                                        child: PostCard(
                                            _latestPosts[index], user, index),
                                      ),
                                  )
                                  : Container(
                                child: PostCard(
                                    _latestPosts[index], user, index),
                              );
                            }, childCount: _latestPosts.length),
                          )
                        ],
                      );
//                : Loader();
          } else {
            return Loader();
          }
        });
  }
}
