import 'package:flutter/material.dart';
import 'package:yourpage/services/auth.dart';
import 'package:yourpage/shared/constants.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String name = '';
  String email = '';
  String password = '';
  String error = '';

  void changeLoadingStatus() {
    setState(() => loading = !loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                // EMAIL
                cursorColor: Colors.purple,
                style: TextStyle(color: Colors.white),
                decoration: textInputDecoration.copyWith(hintText: 'email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                // PASSWORD
                cursorColor: Colors.purple,
                style: TextStyle(color: Colors.white),
                decoration: textInputDecoration.copyWith(hintText: 'password'),
                validator: (val) =>
                    val.length < 6 ? 'Enter 6 + letters password' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.purple,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      // LOGIN
                      if (_formKey.currentState.validate()) {
                        changeLoadingStatus();
                        dynamic result = await _auth.loginWithEmailAndPassword(
                            email, password);
                        if (result == null) {
                          changeLoadingStatus();
                          setState(() => error = 'there has been a problem');
                        }
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
