import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List _allUsers = new List();
  String uid;
  bool _showLoader;
  bool _isLastUser = false;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();

  _getAllUsers() {
    _showLoader = true;
    FirestoreService()
        .getAllUsers(_lastDocument)
        .then((users) => {
              users.documents.forEach((user) => _allUsers.add(user.data)),
              setState(() {
                _showLoader = false;
              })
            })
        .catchError((error) => print(error));
  }

  @override
  void initState() {
    _getAllUsers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_showLoader &&
          !_isLastUser) {
        _getAllUsers();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.uid = Provider.of<String>(context);
    return !_showLoader
        ? _allUsers.length == 0
            ? Text(
                'no posts',
                style: TextStyle(color: Colors.white),
              )
            : CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.purple,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('All users'),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Container(
                          margin: EdgeInsets.all(20.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                _allUsers[index]['accountInfo']['userName'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40),
                              ),
                              RaisedButton(
                                color: Colors.teal,
                                child: Text(
                                  'Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () => Navigator.of(context)
                                    .pushNamed('/profile',
                                        arguments: _allUsers[index]
                                            ['accountInfo']['userName']),
                              )
                            ],
                          ));
                    }, childCount: _allUsers.length),
                  )
                ],
              )
        : Loader();
  }
}
