import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/models/user.dart';
import 'package:yourpage/pages/AppView.dart';
import 'package:yourpage/routing.dart';
import 'package:yourpage/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        accentColor: Colors.purple,
      ),
      home: StreamProvider<String>.value(
        value: AuthService().getUid,
        child: AppView(),
      ),
    );
  }
}
