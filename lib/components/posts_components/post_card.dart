import 'package:yourpage/models/comment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/constants.dart';
import 'package:yourpage/shared/loader.dart';

import 'comments/comments_view.dart';
import 'input.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final post;
  List x = new List();
  final position;
  var postUser;
  final authUser;

  PostCard(this.post, this.authUser, this.position);

  bool _showLikeButton() {
    return post['likes'].contains(authUser['personalInfo']['userId']);
  }

  void _addComment(String comment) {
    Comment newComment = Comment(authUser['accountInfo']['userName'], comment);
    FirestoreService().addComment(this.post, newComment);
  }

  void _toggleLikeButton() {
    if (_showLikeButton()) {
      FirestoreService()
          .togglePostLike(this.post, authUser['personalInfo']['userId'], 0);
    } else {
      FirestoreService()
          .togglePostLike(this.post, authUser['personalInfo']['userId'], 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreService().getUserById(post['userId']), // get post user
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            this.postUser = snapshot.data;
            return Container(
              child: Card(
                color: medGray,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/profile',
                            arguments: postUser['accountInfo']['userName']),
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundImage:
                              NetworkImage(postUser['accountInfo']['imageUrl']),
                        ),
                      ),
                      title: GestureDetector(
                        child: Text(postUser['personalInfo']['name'] +
                            postUser['personalInfo']['lastName']),
                        onTap: () => Navigator.of(context).pushNamed('/profile',
                            arguments: postUser['accountInfo']['userName']),
                      ),
                      subtitle: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              '/profile',
                              arguments: postUser['accountInfo']['userName']),
                          child: Text(postUser['accountInfo']['userName'])),
                      trailing: PopupMenuButton<int>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 0,
                                bottom: 0,
                              ),
                              leading: Icon(Icons.group_add),
                              title: Align(
                                child: Text(
                                  "Follow",
                                  style: TextStyle(color: Colors.white),
                                ),
                                alignment: Alignment(-1.5, 0),
                              ),
                            ),
                            /*Text(
                              "Follow",
                              style: TextStyle(
                                  color: Colors.white),
                            ),*/
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 0,
                                bottom: 0,
                              ),
                              leading: Icon(Icons.delete_outline),
                              title: Align(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                alignment: Alignment(-1.5, 0),
                              ),
                            ),
                            /*Text(
                              "Follow",
                              style: TextStyle(
                                  color: Colors.white),
                            ),*/
                          ),
                        ],
                        icon: Icon(Icons.more_vert),
                        offset: Offset(0, 100),
                      ),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        onPageChanged: null,
                      ),
                      items: post['imagesUrls'].map<Widget>((image) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: image,
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
//                            child: Image.network(image),
                          ),
                        );
                      }).toList(),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                _showLikeButton()
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _toggleLikeButton();
                              },
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                post['title'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 0,
                            right: 15,
                            bottom: 0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              post['caption'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 10,
                            right: 15,
                            bottom: 0,
                          ),
                          child: Row(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: (post['likes'].length).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  TextSpan(
                                      text: ' likes',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300)),
                                ]),
                              ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: ' ' +
                                          (post['comments'].length).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  TextSpan(
                                      text: ' comments',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300)),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                            top: 10,
                            right: 5,
                            bottom: 10,
                          ),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                            child: new Material(
                              color: medGray,
                              child: Comments(post),
                            ),
                          ),
                        ),
                        Input(this._addComment, 'what about a compliment?',
                            'add a comment to the post...'),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            top: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.orange,
                                  ),
                                  Text(post['country'] + ' ,' + post['city']),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.blueAccent,
                                  ),
                                  Text(
                                    DateFormat('dd-MM-yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            post['date'].seconds * 1000)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
            /*return Container(
              child: Column(
                children: <Widget>[
                  Text(postUser['accountInfo']['userName'],
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Image.network(
                    post['imagesUrls'][0],
                  ),
                  Text(post['title'],
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                  Text(post['caption'],
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          _showLikeButton()
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _toggleLikeButton();
                        },
                      ),
                      Text(post['likes'].length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      Icon(Icons.comment),
                      Text(post['comments'].length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                    ],
                  ),
                  Container(
                    color: Colors.grey[800],
                    height: 100,
                    child: Comments(post),
                  ),
                  Input(
                      this.post['postId'],
                      this.addComment,
                      'what about a compliment?',
                      'add a comment (as ' +
                          authUser['accountInfo']['userName']),
                ],
              ),
            );*/
          } else {
            return Loader();
          }
        });
  }
}
