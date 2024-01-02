import 'dart:convert';

import 'package:GreenSign/pages/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


import '../../model/login.dart';
import '../../utils/validator.dart';
import 'forgot_password_screen.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  bool isLoading = false;
  Login? loginResponse;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = 'anilkumar.v@digitelenetworks.com';
    _passwordController.text = 'Greenko@123';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 150,
                      child: Image.asset('assets/images/digisign_black_title_logo.png'),
                    ),
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid email id as abc@gmail.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password', hintText: 'Enter secure password'),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(color: Color(0xFF3B82F6), borderRadius: BorderRadius.circular(30)),
                  child: MaterialButton(
                    onPressed: () {
                      String _username = _usernameController.text.trim();
                      String _password = _passwordController.text.trim();

                      String emailValidationMessage = Validators.validateEmail(_username);
                      String passwordValidationMessage = Validators.validatePassword(_password);

                      if (emailValidationMessage.isEmpty) {
                        if (passwordValidationMessage.isEmpty) {
                          // isLoading = true;

                          login(_username, _password);

                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (_) => WebViewScreen("","")));

                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(passwordValidationMessage)));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(emailValidationMessage)));
                      }
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen()));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                    child: Center(
                  child: isLoading ? CircularProgressIndicator() : Text(''),
                ))
                // Text('New User? Create Account')
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  login(String username, String password) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // await Future.delayed(Duration(seconds: 3));

    try {
      final response =
          await http.post(
            Uri.parse('http://10.80.13.29:8000/login'),
            body: jsonEncode({'email_address': username, 'password': password}),
            headers: {'Content-Type': 'application/json'},
          );

         // final response =  MockResponses.mockLoginResponse;

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          // Successful login
          // You can handle the response here (e.g., store tokens, navigate to the next screen)
          print('Login successful');
          print(jsonResponse);
          loginResponse = Login.fromJson(jsonResponse);
          print(loginResponse?.data?.id);

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("loginUser", loginResponse!.data!.id??"");
          prefs.setString("user_id", loginResponse!.data!.id??"");
          prefs.setString("auth_token", loginResponse!.data!.token??"");

          // Navigator.push(context, MaterialPageRoute(builder: (_) => WebView("")));


          Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage(loginResponse!.data?.id)));
        } else {
          // Handle invalid or empty JSON response
          print('Invalid JSON response');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some thing went wrong')));
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        // Failed login
        // Handle error here (e.g., show an error message)
        print('Login failed $response.statusCode');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some thing went wrong')));
      }
    } catch (error) {
      // Handle network or other errors here
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }
}
