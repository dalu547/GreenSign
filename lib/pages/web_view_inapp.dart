import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();

}

Future<void> getStringFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString('loginUser'); // Replace 'key' with your preference key
  if (stringValue != null) {
    // Use the retrieved string value
    print('String from SharedPreferences: $stringValue');
  } else {
    // Handle the case where the value doesn't exist
    print('String not found in SharedPreferences');
  }
}

class _MyWebViewState extends State<MyWebView> {

  InAppWebViewController? webViewController;


  @override
  void initState() {
    super.initState();

    getStringFromSharedPreferences();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter WebView"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            // url: Uri.parse("http://10.80.16.166:4200/login"), // Replace with your web page URL

        url: Uri.parse("http://10.80.16.166:4200/recipient-docs-list?envelope_id=655b287b556a19a9ccfa2c1a&sender_id=64cdeaff24f228a98a501b5c"), // Replace with your web page URL
        ),


        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            // debuggingEnabled: true,
          ),
        ),


        onWebViewCreated: (InAppWebViewController controller) {
          // Inject JavaScript to access the token and use it as needed
          // controller.evaluateJavascript(
          //   source: "localStorage.getItem('loginUser');",
          // );

          webViewController = controller;

          webViewController?.evaluateJavascript(source: "console.log('WebView created');");


          final envelope_id = "654c896de29b874270e10541"; // Replace with the actual user ID
          final sender_id = "64cb5370930845c5c4b012c0";
          // webViewController?.evaluateJavascript(source: 'var envelope_id = $envelope_id;');

          // Call the Angular method
          // webViewController?.evaluateJavascript(
          // source: "sendEnvelopeId();",
          // );

          _setLocalStorageItem(controller);


        },

        onLoadStop: (controller, url) async {

          // Handle other WebView events as needed
           print("onLoadStop : sendEnvelopeId");
           // await controller?.evaluateJavascript(source: "sendEnvelopeId();");

           await controller?.evaluateJavascript(source: "console.log('Test JavaScript Bridge');");

           _getLocalStorageItem(controller);


          },

          // onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
          //   print("onConsoleMessage : ${consoleMessage.message}");
          // }

      ),
    );
  }

  void _setLocalStorageItem(InAppWebViewController controller) async {
    // Get the WebView controller

    // Execute JavaScript to set an item in local storage
     await controller.evaluateJavascript(
        source: 'localStorage.setItem("user_id", "405");');
  }

  void _getLocalStorageItem(InAppWebViewController controller) async {
    // Execute JavaScript to get an item from local storage
    var result = await controller.evaluateJavascript(
        source: 'localStorage.getItem("user_id");');

    print('Item from local storage: $result');
  }

}





