import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<WebView> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          _setLocalStorageItem();
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
            print('onProgress');
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
            print('onPageFinished');

            controller.runJavaScript("console.log('Test JavaScript Bridge');");
            // controller.runJavaScript("alert('Test JavaScript Bridge alert');");

            controller.runJavaScript("sendEnvelopeId();");
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
        // Uri.parse('https://flutter.dev/'),
        Uri.parse(
            'http://10.80.16.166:4200/recipient-docs-list?envelope_id=656f1074e9be6c5ebec0d646&sender_id=64cb5370930845c5c4b012c0'),
      );
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
