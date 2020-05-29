import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/constants.dart';
import 'package:yourpage/shared/loader.dart';

class EditProfile extends StatefulWidget {
  final uid;

  EditProfile({
    Key key,
    @required this.uid,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String bio = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreService().getUserById(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data;
            var socialLinks = user['accountInfo']['socialLinks'];
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text('Edit profile'),
                backgroundColor: Colors.transparent,
              ),
              body: Column(
                children: <Widget>[
                  ClipRRect(
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
                      )),
                  Text(
                    'EDIT PROFILE,' + user['personalInfo']['name'],
                    style: TextStyle(fontSize: 40),
                  ),
                  TextFormField(
                    // BIOGRAPHY
                    initialValue: user['accountInfo']['bio'],
                    cursorColor: Colors.purple,
                    style: TextStyle(color: Colors.white),
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Biography'),
                    maxLines: 5,
//                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => bio = val);
                    },
                  ),
                  TextFormField(
                    // BIOGRAPHY
                    initialValue: socialLinks['facebook'],
                    cursorColor: Colors.purple,
                    style: TextStyle(color: Colors.white),
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Facebook'),
//                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => bio = val);
                    },
                  ),
                  RaisedButton(
                    color: Colors.purple,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
//                      if (_formKey.currentState.validate()) {
//                        changeLoadingStatus();
                      dynamic result = await FirestoreService()
                          .updateUser(user['personalInfo']['userId'], bio);
                      if (result == null) {
//                          changeLoadingStatus();
//                          setState(() => error = 'there has been a problem');
                      }
//                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return Loader();
          }
        });
  }
}
