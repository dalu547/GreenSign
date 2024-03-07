import 'package:DigiSign/pages/sfpdf_viewer_demo.dart';
import 'package:DigiSign/pages/splash_screen.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

    );
  }
}