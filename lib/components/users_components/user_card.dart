import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserCard extends StatelessWidget {
  final user;

  UserCard(this.user);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: null,
          child: Container(
            child: Image.network(
              user['accountInfo']['imageUrl'],
              width: 100,
              height: 100,
            ),
          ),
        ));
  }
}
