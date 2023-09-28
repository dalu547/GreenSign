import 'package:GreenSign/project/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'poc/splashScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage()
    );
  }
}