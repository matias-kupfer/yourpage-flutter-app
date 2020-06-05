import 'package:flutter/material.dart';
import 'package:yourpage/shared/constants.dart';

class UserSmallCard extends StatelessWidget {
  final user;

  UserSmallCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: medGray,
      child: ListTile(
        leading: GestureDetector(
          child: CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(user['accountInfo']['imageUrl']),
          ),
        ),
        title: Text(
          user['personalInfo']['name'] + ' ' + user['personalInfo']['lastName'],
          style: TextStyle(fontSize: 25),
        ),
        subtitle: Text('@' + user['accountInfo']['userName']),
        trailing: RaisedButton(
          color: Colors.purple,
          child: Text('Profile'),
          onPressed: () => Navigator.of(context).pushNamed('/profile',
              arguments: user['accountInfo']['userName']),
        ),
      ),
    );
  }
}
