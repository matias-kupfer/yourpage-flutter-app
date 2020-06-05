import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourpage/components/users_components/statistics.dart';
import 'package:yourpage/pages/profile/edit_profile.dart';
import 'package:yourpage/pages/profile/posts_components/new_post.dart';
import 'package:yourpage/pages/profile/visitProfile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/profile':
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => VisitProfile(
                    userName: args,
                  ));
        }
        break;
      case '/edit_profile':
        return MaterialPageRoute(
          builder: (_) => EditProfile(
            uid: args,
          ),
        );
        break;
      case '/new_post':
        return MaterialPageRoute(
            builder: (_) => NewPost(
                  uid: args,
                ));
        break;
      case '/statistics':
        return MaterialPageRoute(
            builder: (_) => Statistics(
                  user: args,
                ));
        break;
    }
  }
}
