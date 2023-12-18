import 'package:GreenSign/pages/dashboard_new.dart';
import 'package:GreenSign/pages/reports_web_view.dart';
import 'package:flutter/material.dart';

import 'inbox_new.dart';
import 'more.dart';

class HomePage extends StatefulWidget {
  String user_id;

  HomePage(this.user_id);

  @override
  _HomePageState createState() => _HomePageState(user_id);
}

class _HomePageState extends State {
  int _selectedTab = 0;
  List<Widget> _pages = [];

  String user_id = "";

  _HomePageState(this.user_id);

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _pages = [
      DashBoardNew("", () => _changeTab(1)),
      InboxNew(""),
      ReportsWebView(),
      More(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
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
    );
  }
}
