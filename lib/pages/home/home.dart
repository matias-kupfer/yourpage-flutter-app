import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/pages/home/all_posts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
//    _getLatestPostsInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    return Container(color: Color(0xff1a1a1a), child: AllPosts());
  }
}
/*  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    return !_showLoader
        ? Container(
            child: _latestPosts.length > 0
                ? AllPosts()
                : Text(
                    'no posts',
                    style: TextStyle(color: Colors.white),
                  ),
          )
        : Loader();
  }
}*/
