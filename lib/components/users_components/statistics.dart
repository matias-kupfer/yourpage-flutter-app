import 'package:flutter/material.dart';
import 'package:yourpage/components/users_components/user_small_card.dart';
import 'package:yourpage/services/firestore.dart';
import 'package:yourpage/shared/loader.dart';

class Statistics extends StatefulWidget {
  final user;

  Statistics({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User info"),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.purple,
          tabs: [
            Tab(
              icon: Icon(Icons.group),
              text: 'Followers',
            ),
            Tab(
              icon: Icon(Icons.check),
              text: 'Following',
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          widget.user['followers'].length != 0
              ? CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return StreamBuilder(
                            stream: FirestoreService()
                                .getUserById(widget.user['followers'][index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var user = snapshot.data;
                                return UserSmallCard(user);
                              } else {
                                return Loader();
                              }
                            });
                      }, childCount: widget.user['followers'].length),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'The user has no followers',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
          widget.user['following'].length != 0
              ? CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return StreamBuilder(
                            stream: FirestoreService()
                                .getUserById(widget.user['following'][index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var user = snapshot.data;
                                return UserSmallCard(user);
                              } else {
                                return Loader();
                              }
                            });
                      }, childCount: widget.user['following'].length),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'The user does not follow anyone',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
        controller: _tabController,
      ),
    );
  }
}
