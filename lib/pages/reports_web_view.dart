import 'package:GreenSign/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReportsWebView extends StatefulWidget {
  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<ReportsWebView> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          _setLocalStorageItem();
          setState(() {
            loadingPercentage = 0;
            isLoading = true;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
            isLoading = true;

            print('onProgress');
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
            isLoading = false;

            print('onPageFinished');

            controller.runJavaScript("console.log('Test JavaScript Bridge');");
            // controller.runJavaScript("alert('Test JavaScript Bridge alert');");

            controller.runJavaScript("sendEnvelopeId();");
          });
        },
        onWebResourceError: (WebResourceError error) {
          print(error);
          // Handle errors and dismiss loader
          setState(() {
            isLoading = false;
          });
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(
        // Uri.parse('http://10.80.16.166:4200/recipient-docs-list?envelope_id=655b2dfa556a19a9ccfa2c38&sender_id=64cb5370930845c5c4b012c0'),
        Uri.parse(AppConstants.ENVELOPE_WEB_URL+"/envelope-report"),
        //   Uri.parse(
        //       'http://10.80.16.166:4200/recipient-docs-list?envelope_id=656f1074e9be6c5ebec0d646&sender_id=64cb5370930845c5c4b012c0'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reports'),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
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
