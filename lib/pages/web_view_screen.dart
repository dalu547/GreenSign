import 'package:GreenSigner/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class WebViewScreen extends StatefulWidget {
  String? envelope_id = "";
  String? sender_id = "";
  String? user_id = "";

  WebViewScreen(this.envelope_id, this.sender_id);

  @override
  _WebviewState createState() => _WebviewState(envelope_id, sender_id);
}

class _WebviewState extends State<WebViewScreen> {
  late WebViewController controller;
  var loadingPercentage = 0;
  bool isLoading = false;

  String? envelope_id = "";
  String? user_id = "";
  String? sender_id = "";
  String? user_id_prefs = "";
  String? auth_token = "";

  _WebviewState(this.envelope_id, this.sender_id);

  @override
  void initState() {
    super.initState();

    controller = WebViewController();
    getUserData();
  }

  Future<void> getData() async {
    super.initState();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
  }

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
    print('user id from SF ${user_id_prefs}');
    auth_token = prefs.getString('auth_token')!;

    // String webUrl =
    //     "${AppConstants.ENVELOPE_WEB_URL}/recipient-docs-list?envelope_id=${envelope_id!}&sender_id=${sender_id!}&user_id=${user_id_prefs!}&token=${auth_token!}&type=mobile";

    String webUrl =
        "${AppConstants.ENVELOPE_WEB_URL}/mobile-interface?envelope_id=${envelope_id!}&sender_id=${sender_id!}&user_id=${user_id_prefs!}&token=${auth_token!}&type=mobile&page=recipient-docs-list";

    print("Web url in webview: " + webUrl);

    controller
      ..loadRequest(
        Uri.parse(webUrl),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "messageHandler",
        onMessageReceived: (JavaScriptMessage javaScriptMessage) {
          print("message from the web view=\"${javaScriptMessage.message}\"");
          if(javaScriptMessage.message=="FINISH"){
              Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage("")));
          }
        },
      )

      //Navigation Delegate
      ..setNavigationDelegate(NavigationDelegate(
        //page start
        onPageStarted: (url) {
          _setLocalStorageItem();
          setState(() {
            loadingPercentage = 0;
            isLoading = true;
          });
        },

        //page inprogress
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
            isLoading = true;
            print('onProgress');
          });
        },

        //page finished
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
            isLoading = false;

            print('onPageFinished');

            controller.runJavaScript("console.log('Login test');");
            // controller.runJavaScript("alert('Test JavaScript Bridge alert');");

            controller.runJavaScript("login();");
          });
        },
        //webresource error
        onWebResourceError: (WebResourceError error) {
          print(error);
          // Handle errors and dismiss loader
          setState(() {
            isLoading = false;
          });
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Digi Sign'),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
                backgroundColor: Colors.grey, // Set the background color
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), //
              ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ));
  }

  void _setLocalStorageItem() async {
    // Get the WebView controller

    // Execute JavaScript to set an item in local storage
    await controller
        .runJavaScript('localStorage.setItem("test_emp_id", "405");');

    _getLocalStorageItem();
  }

  void _getLocalStorageItem() async {
    // Execute JavaScript to get an item from local storage
    var result = await controller
        .runJavaScriptReturningResult('localStorage.getItem("test_emp_id");');

    print('Item from local storage: $result');
  }
}
