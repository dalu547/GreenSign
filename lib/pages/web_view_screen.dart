import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewScreen extends StatefulWidget {
  String? envelope_id = "";
  String? sender_id = "";
  String? user_id = "";

  WebViewScreen(this.envelope_id,this.sender_id);

  @override
  _WebviewState createState() => _WebviewState(envelope_id,sender_id);
}

class _WebviewState extends State<WebViewScreen> {
  late WebViewController controller;
  var loadingPercentage = 0;
  bool isLoading = false;

  String? envelope_id = "";
  String? user_id = "";
  String? sender_id = "";
  String? user_id_prefs = "";

  _WebviewState(this.envelope_id, this.sender_id);

  @override
  void initState() {
    super.initState();

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

    // http://10.80.16.166:4200/recipient-docs-list?
    // envelope_id=658ea8a948e8f9187d6a882f
    // &sender_id=64cded5d24f228a98a501b6c
    // &user_id=64cdecf924f228a98a501b68


    String web_url =
        "http://10.80.16.245:4200/recipient-docs-list?envelope_id=" +
            envelope_id! +
            "&sender_id=" +
            sender_id! +
            "&user_id=" +
            user_id_prefs!;


    // String web_url  = 'http://10.80.16.166:4200/recipient-docs-list?envelope_id=658eaa4748e8f9187d6a883f&sender_id=64cdecf924f228a98a501b68&user_id=64cdecf924f228a98a501b68';
    print("Web url in webview: " + web_url);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "messageHandler",
        onMessageReceived: (JavaScriptMessage javaScriptMessage) {
          print("message from the web view=\"${javaScriptMessage.message}\"");
        },
      )
      ..loadRequest(
        Uri.parse(web_url),
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
