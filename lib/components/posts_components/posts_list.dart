import 'package:flutter/material.dart';

class PostsList extends StatelessWidget {
  final List _posts;
  ScrollController controller;

  PostsList(this._posts);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _posts.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 400,
            margin: EdgeInsets.all(8.0),
            color: Colors.purple,
            child: Text(_posts[index]['title'],
                style: TextStyle(color: Colors.white)));
      },
    );
  }
}
