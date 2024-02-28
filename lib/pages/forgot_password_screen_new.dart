import 'package:flutter/material.dart';

import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_screen.dart';

class ForgotPasswordScreenNew extends StatefulWidget {

  @override
  State<ForgotPasswordScreenNew> createState() => _ForgotPasswordStateNew();

}

class _ForgotPasswordStateNew extends State<ForgotPasswordScreenNew> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Center(
                child: Container(
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/digisign_black_title_logo.png')),
              ),
            ),
            SizedBox(height: 20),
            Text('Forgot password',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xFF1E293B))),
            SizedBox(height: 20),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text('You will be redirected to Greenko Intranet Application. Please click below for Forgot Password.',
                  style: TextStyle(fontSize: 14)),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: MaterialButton(
                onPressed: () {
                  _launchURL('https://intranet.greenkogroup.com/forgot-password');
                },
                child: Text(
                  'Click here for Forgot Password.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
                logoutAndNavigateToLogin(context);
              },
              child: Text(
                'Back to Login',
                style: TextStyle(color: Colors.blue, fontSize: 14,fontWeight: FontWeight.w400,decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            // Text('New User? Create Account')
          ],
        ),
      ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  logoutAndNavigateToLogin(BuildContext context) async {
    // Clear user authentication details or perform any necessary cleanup
    // For example, you might clear the user token or reset the authentication state

    // Navigate to the login screen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_logged_in", false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );

  }

}
