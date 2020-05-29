import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/components/users_components/profile_card.dart';
import 'package:yourpage/services/auth.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class VisitProfile extends StatefulWidget {
  final userName;

  VisitProfile({
    Key key,
    @required this.userName,
  }) : super(key: key);

  @override
  _VisitProfileState createState() => _VisitProfileState();
}

class _VisitProfileState extends State<VisitProfile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirestoreService().getUserByUsername(widget.userName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data.documents[0];
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                /*title: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.teal,
                    ),
                    onPressed: null,
                  ),*/
              ),
              body: StreamProvider<String>.value(
                  value: AuthService().getUid, child: ProfileCard(user)),
            );
          } else {
            return Loader();
          }
        });
  }
}
