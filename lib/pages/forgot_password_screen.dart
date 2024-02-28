import 'package:flutter/material.dart';

import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();

}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {

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
              child: Text('Enter your email address and we will send you the recovery link',
                  style: TextStyle(fontSize: 14)),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id.'),
              ),
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

                    logoutAndNavigateToLogin(context);

                },
                child: Text(
                  'Send',
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
                style: TextStyle(color: Colors.blue, fontSize: 14,fontWeight: FontWeight.w400),
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
