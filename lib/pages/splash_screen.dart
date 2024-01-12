import 'dart:async';
import 'package:GreenSign/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    navigateToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF725CF8),
              Color(0xFF1ED4D4),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/digisign_white_title_logo.png'),
              SizedBox(height: 8),
              Text('eSignature App',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        color: Color(0xFF1ED4D4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Powered by GreenkoGroup',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
 navigateToNextPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in')??false;

    if (isLoggedIn) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => HomePage(""))));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen())));
    }
  }
}
