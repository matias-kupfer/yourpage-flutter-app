import 'package:flutter/material.dart';
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

  Widget _buildBio() {
    return TextFormField(
      decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          hintText: 'Where are you from, what do you like...',
          labelText: 'Write something about yourself',
          labelStyle: TextStyle(color: Colors.purple)),
      maxLines: 5,
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'What\'s a post without a caption?';
        }
        if (value.length > 200) {
          return 'The caption is too long';
        }
      },
      onSaved: (String value) {
        bio = value;
      },
    );
  }

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
              body: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 8, right: 15, bottom: 8),
                child: Column(
                  children: <Widget>[
                    _buildBio(),
                    RaisedButton(
                        color: Colors.purple,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            dynamic result = await FirestoreService()
                                .updateUser(
                                    user['personalInfo']['userId'], bio);
                          }
                        }),
                  ],
                ),
              ),
            );
          } else {
            return Loader();
          }
        });
  }
}
