import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:yourpage/services/api.dart';
import 'package:yourpage/shared/constants.dart';
import 'dart:convert' as convert;

class UserCard extends StatelessWidget {
  final uid;
  final user;

  UserCard(this.uid, this.user);

  String _getDate() {
    var birthday = new DateTime.fromMillisecondsSinceEpoch(
        user['personalInfo']['birthday'].seconds * 1000);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    int month1 = currentDate.month;
    int month2 = birthday.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthday.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }

  _toggleFollow(action) {
    var jsonResponse;
    Api()
        .toggleFollow(uid, user['personalInfo']['userId'], action)
        .then((response) => {
              print(response.statusCode),
              if (response.statusCode == 200)
                {
                  jsonResponse = convert.jsonDecode(response.body),
                  print(jsonResponse)
                }
              else
                {print('ERROR')}
            });
  }

  int _isFollowing() {
    // 0 same user - 1 following - 2 not following
    return user['personalInfo']['userId'] == uid
        ? 0
        : user['followers'].contains(uid) ? 1 : 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          /*CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) =>
            new CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
            new Icon(Icons.error),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),*/
          Column(
            children: <Widget>[
              CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage(user['accountInfo']['imageUrl']),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  hoverColor: Colors.purple,
                  textColor: Colors.purple,
                  highlightedBorderColor: Colors.purple,
                  borderSide: BorderSide(color: Colors.purple),
                  child: _isFollowing() == 0
                      ? Text('edit profile')
                      : _isFollowing() == 1 ? Text('Unfollow') : Text('Follow'),
                  onPressed: () => {
                    _isFollowing() == 1
                        ? _toggleFollow(1)
                        : _isFollowing() == 2
                            ? _toggleFollow(0)
                            : Navigator.of(context)
                                .pushNamed('/edit_profile', arguments: uid)
                  },
                ),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      user['personalInfo']['name'] +
                          ' ' +
                          user['personalInfo']['lastName'] +
                          ', ' +
                          _getDate(),
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed('/statistics', arguments: user),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Text(
                              (user['followers']).length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              (user['following']).length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              (user['posts']).toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ]),
                          TableRow(children: [
                            Text(
                              'Followers',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: lightGray),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Following',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: lightGray),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: lightGray),
                              textAlign: TextAlign.center,
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      user['accountInfo']['bio'],
                      style: TextStyle(color: lightGray),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.orange,
                            ),
                            Text('location'),
//                            Text(user['accountInfo']['country']),
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
                                      user['accountInfo']['registrationDate']
                                              .seconds *
                                          1000)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /*Table(
                    children: [
                      TableRow(children: [
                        Text((user['followers']).length.toString()),
                        Text((user['following']).length.toString()),
                        Text((user['posts']).toString()),
                      ]),
                      TableRow(children: [
                        Text('Followers'),
                        Text('Following'),
                        Text('Posts'),
                      ]),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
    /*return Card(
      color: medGray,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(user['accountInfo']['imageUrl']),
            ),
            title: Text(user['personalInfo']['name'] +
                user['personalInfo']['lastName']),
            subtitle: Text(user['accountInfo']['userName']),
          ),
          Text(user['accountInfo']['bio'], style: TextStyle(fontSize: 30),)
        ],
      ),
    );*/
  }
}
