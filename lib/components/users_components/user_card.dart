import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yourpage/shared/constants.dart';

class UserCard extends StatelessWidget {
  final user;

  UserCard(this.user);

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
          CircleAvatar(
            radius: 60.0,
            backgroundImage: NetworkImage(user['accountInfo']['imageUrl']),
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
                            Text(user['accountInfo']['country']),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Colors.blueAccent,
                            ),
                            Text('date'
                                /*DateFormat('dd-MM-yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  user['date'].seconds * 1000)),*/
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
