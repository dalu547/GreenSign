
import 'package:flutter/material.dart';
import 'add_signature.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'select_file.dart';
import 'splashscreen.dart';


class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}

class SignInScreen extends StatefulWidget {

  @override
  State<SignInScreen> createState() => _SignInScreenState();

}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _filePath = "/storage/emulated/0/Download/greensign_test.pdf";

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>

             SplashScreen()

          ) );
        },
      ),

      title: Text('Login'),

    ),
    body: Container(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(0.0),
                // child: Center(
                  child: Container(
                      width: 200,
                      height: 60,
                      /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('assets/images/greenko_logo.png')
                  ),
                // ),
              ),

              // Text('Login',
              //     style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Email ID'),
                controller: _usernameController,

              ),
              SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: 40,),
              MaterialButton(
                minWidth: double.infinity,
                height: 45,
                onPressed: () {
                   _requestFilePermissionAndReadFile();
                },
                color: Colors.green,
                child: Text('Login', style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ),
      ),
  );



// Function to request file access permission and read the file
  Future<void> _requestFilePermissionAndReadFile() async {
    // Check if the app has permission to access files
    if (await _requestFilePermission()) {
      // Permission granted, read the file
      _readFileContents();
    } else {
      // Permission denied, show an error dialog or handle the case as per your app's requirements
      _showPermissionErrorDialog();
    }
  }

// Function to request file access permission
  Future<bool> _requestFilePermission() async {
    if (await Permission.storage
        .request()
        .isGranted) {
      return true;
    } else {
      return false;
    }
  }

// Function to read the file contents
  void _readFileContents() {
    try {
      // File file = File(_filePath);
      // if (file.existsSync()) {
        // String content = file.readAsStringSync();
        // print("File contents: $content");

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>

            SelectFile()

        ));


      // } else {
      //   print("File does not exist.");
      // }
    } catch (e) {
      print("Error reading file: $e");
    }
  }

// Function to show an error dialog for permission denial
  void _showPermissionErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Permission Denied"),
          content: Text(
              "Please grant file access permission to read the file."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


}
