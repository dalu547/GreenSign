import 'package:GreenSign/pages/dashboard_new.dart';
import 'package:GreenSign/pages/reports_web_view.dart';
import 'package:flutter/material.dart';

import 'inbox.dart';
import 'inbox_new.dart';
import 'more.dart';

class HomePage extends StatefulWidget {
  String? user_id;

  HomePage(this.user_id);

  @override
  _HomePageState createState() => _HomePageState(user_id);
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  List<Widget> _pages = [];

  String? user_id = "";
  int type = 0;

  _HomePageState(this.user_id);

  _changeTab(int index, int box_index) {
    setState(() {
      type = box_index;
      _selectedTab = index;
      print("type in change tab $type");
    });
  }

  @override
  void initState() {
    super.initState();
    _updatePages(); // Initialize pages
  }

  void _updatePages() {
    _pages = [
      DashBoardNew("", (int box_index) {
        _pages[1] = InboxNew(type);
        print("type in home $box_index");
        type = box_index;
        _changeTab(1, box_index);
      }),
      InboxNew(type), // Create InboxNew widget dynamically
      ReportsWebView(),
      More(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable the physical back button
        return false;
      },
      child: Scaffold(
        body: _pages.elementAt(_selectedTab),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index, type),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Image.asset('assets/images/home_inactive.png'),
              activeIcon: Image.asset('assets/images/home_active.png'),
            ),
            BottomNavigationBarItem(
              label: 'Manage',
              icon: Image.asset('assets/images/inbox_inactive.png'),
              activeIcon: Image.asset('assets/images/inbox_active.png'),
            ),
            BottomNavigationBarItem(
              label: 'Reports',
              icon: Image.asset('assets/images/reports_inactive.png'),
              activeIcon: Image.asset('assets/images/reports_active.png'),
            ),
            BottomNavigationBarItem(
              label: 'More',
              icon: Image.asset('assets/images/more_inactive.png'),
              activeIcon: Image.asset('assets/images/more_active.png'),
            ),
          ],
        ),
      ),
    );
  }
}
