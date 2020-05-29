import 'package:flutter/material.dart';
import 'package:yourpage/pages/profile/profile_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    /*switch(settings.name) {
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile(data: args,))
    }*/
  }
}