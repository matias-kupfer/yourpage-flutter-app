import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/pages/users/all_users.dart';

class Users extends StatefulWidget {

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    return Container(
        color: Color(0xff1a1a1a), child: AllUsers());
  }
}
