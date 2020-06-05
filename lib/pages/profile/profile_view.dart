import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/components/users_components/profile_card.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    return StreamBuilder(
        stream: FirestoreService().getUserById(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data;
            return ProfileCard(user, true);
          } else {
            return Loader();
          }
        });
  }
}
