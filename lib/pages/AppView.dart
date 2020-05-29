import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/pages/home/home.dart';
import 'package:yourpage/pages/auth/login.dart';
import 'package:yourpage/pages/profile/profile_view.dart';
import 'package:yourpage/pages/users/users.dart';
import 'package:yourpage/services/auth.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class AppView extends StatefulWidget {
  @override
  _AppView createState() => _AppView();
}

class _AppView extends State<AppView> with TickerProviderStateMixin {
  final navigatorKey = GlobalKey<NavigatorState>();
  int _tab = 0;

  void _onTabSelectorTap(int index) {
    setState(() {
      _tab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    return uid != null
        ? StreamBuilder(
            stream: FirestoreService().getUserById(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var user = snapshot.data;
                return Scaffold(
                  resizeToAvoidBottomPadding: false,
                  body: _tab == 0
                      ? Home()
                      : _tab == 1 ? Users() : _tab == 2 ? null : Profile(),
                  backgroundColor: Color(0xff111111),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  floatingActionButton: SpeedDial(
                    animatedIcon: AnimatedIcons.menu_close,
                    overlayColor: Colors.grey[900],
                    curve: Curves.bounceIn,
                    overlayOpacity: 0.6,
                    children: [
                      SpeedDialChild(
                          child: Icon(Icons.add),
                          backgroundColor: Colors.green,
                          label: 'new post',
                          onTap: () => Navigator.of(context).pushNamed(
                              '/new_post',
                              arguments: user['personalInfo']['userId']),
                          labelStyle: TextStyle(color: Colors.grey[900])),
                      SpeedDialChild(
                          child: Icon(Icons.edit),
                          backgroundColor: Colors.orangeAccent,
                          label: 'edit profile',
                          onTap: () => Navigator.of(context).pushNamed(
                              '/edit_profile',
                              arguments: user['personalInfo']['userId']),
                          labelStyle: TextStyle(color: Colors.grey[900])),
                      SpeedDialChild(
                          child: Icon(Icons.power_settings_new),
                          backgroundColor: Colors.red,
                          label: 'logout',
                          onTap: () => AuthService().signOut(),
                          labelStyle: TextStyle(color: Colors.grey[900])),
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: Colors.grey[900],
                    currentIndex: _tab,
                    selectedIconTheme: IconThemeData(color: Colors.purple),
                    unselectedItemColor: Colors.white30,
                    showUnselectedLabels: false,
                    showSelectedLabels: true,
                    iconSize: 30,
                    type: BottomNavigationBarType.fixed,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(OMIcons.home),
                        title: Text(
                          'home',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(OMIcons.group),
                        title: Text(
                          'users',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(OMIcons.search),
                        title: Text(
                          'search',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(OMIcons.person),
                        title: Text(
                          'profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    onTap: _onTabSelectorTap,
                  ),
                );
              } else {
                return Loader();
              }
            })
        : LoginView();
  }
}

/*
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:yourpage/pages/home/home.dart';
import 'package:yourpage/pages/auth/login.dart';
import 'package:yourpage/pages/profile/profile_view.dart';
import 'package:yourpage/pages/users/users.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class AppView extends StatefulWidget {
  @override
  _AppView createState() => _AppView();
}

class _AppView extends State<AppView> {
  int _tab = 0;

  void _onTabSelectorTap(int index) {
    setState(() {
      _tab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    return StreamBuilder(
        stream: FirestoreService().getUserById(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              body: _tab == 0
                  ? Home()
                  : _tab == 1
                  ? Users()
                  : _tab == 2
                  ? null
                  : uid != null ? Profile() : LoginView(),
              backgroundColor: Color(0xff111111),
              floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.purple,
                child: Icon(Icons.add),
                onPressed: null,
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.grey[900],
                currentIndex: _tab,
                selectedIconTheme: IconThemeData(color: Colors.purple),
                unselectedItemColor: Colors.white30,
                showUnselectedLabels: false,
                showSelectedLabels: true,
                iconSize: 30,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(OMIcons.home),
                    title: Text(
                      'home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(OMIcons.group),
                    title: Text(
                      'users',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(OMIcons.search),
                    title: Text(
                      'search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(OMIcons.person),
                    title: Text(
                      'profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                onTap: _onTabSelectorTap,
              ),
            );
          } else {
            return Loader();
          }
        });
  }
}
*/
