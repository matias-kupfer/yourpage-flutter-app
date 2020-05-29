import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/components/posts_components/comments/comments_view.dart';
import 'package:yourpage/components/posts_components/input.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final post;
  final togglePostLike;
  final addComment;
  final position;
  String uid;

  PostCard(this.post, this.togglePostLike, this.addComment, this.position);

  bool _showLikeButton() {
    return post['likes'].contains(this.uid);
  }

  void _toggleLikeButton() {
    if (_showLikeButton()) {
      post['likes'].removeWhere((likeUid) => likeUid == this.uid);
      this.togglePostLike(this.post, 0);
    } else {
      post['likes'].add(this.uid);
      this.togglePostLike(this.post, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.uid = Provider.of<String>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Text(post['title'],
              style: TextStyle(color: Colors.white, fontSize: 50)),
          Image.network(
            post['imagesUrls'][0],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  _showLikeButton() ? Icons.favorite : Icons.favorite_border,
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
          Input(this.post['postId'], this.addComment, position,
              'what about a compliment?', 'add a comment'),
        ],
      ),
    );
  }
}
