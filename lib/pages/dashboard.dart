import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/user_controller.dart';
import '../../model/envelope_count.dart';
import 'inbox.dart';

class DashBoard extends StatefulWidget {
  String user_id;

  DashBoard(this.user_id);

  // @override
  // _HomeScreenState createState() => _HomeScreenState();

  @override
  State<StatefulWidget> createState() {
    return _DashBoardState(this.user_id);
  }
}

class _DashBoardState extends State<DashBoard> {
  String user_id;
  String user_id_prefs = "";

  _DashBoardState(this.user_id);

  UserController _controller = UserController();
  EnvelopeCount? envelopeCount;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getPrefsData();
    fetchEnvelopeCount(user_id_prefs);

  }


  void getPrefsData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id_prefs = prefs.getString('user_id')!;
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset('assets/images/greenko_logo_grade.png'),
        title: Image.asset('assets/images/digisign_title_logo_small.png'),
        actions: [
          Image.asset('assets/images/profile_pic.png'),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xFFE2E8F0)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/action_required_icon.png'),
                                SizedBox(width: 16),
                                Text(
                                    '$envelopeCount!.data.actionRequired',
                                    style: TextStyle(fontSize: 24))
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('Action Required',
                                style: TextStyle(fontSize: 12,color: Color(0xFF64748B)))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xFFE2E8F0)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/waiting_for_others_icon.png'),
                                SizedBox(width: 16),
                                Text(
                                    '$envelopeCount!.data.waitingForOthers',
                                    style: TextStyle(fontSize: 24))
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('Waiting for Others',
                                style: TextStyle(fontSize: 12,color: Color(0xFF64748B)))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xFFE2E8F0)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/expiring_soon_icon.png'),
                                SizedBox(width: 16),
                                Text(
                                    '$envelopeCount!.data.expiringSoon',
                                    style: TextStyle(fontSize: 24))
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('Expiring soon',
                                style: TextStyle(fontSize: 12,color: Color(0xFF64748B)))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xFFE2E8F0)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/completed_icon.png'),
                                SizedBox(width: 16),
                                Text('$envelopeCount!.data.completed',
                                    style: TextStyle(fontSize: 24))
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('Completed',
                                style: TextStyle(fontSize: 12,color: Color(0xFF64748B)))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 320,
              height: 350,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF725CF8),
                    Color(0xFF1ED4D4),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/envelope_icon.png'),
                  SizedBox(height: 16),
                  Text(
                      "You have " +'$envelopeCount!.data.actionRequired',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  Text("Envelopes to finish",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  SizedBox(height: 16),
                  Container(
                      child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : Text(''),
                  )),
                  MaterialButton(
                    color: Colors.white,
                    minWidth: 200,
                    height: 40,
                    elevation: 8,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Inbox(0)));
                    },
                    child: Text(
                      'Open',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the radius as needed
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Example Dialog'),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  fetchEnvelopeCount(String userId) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });


    try {
      final response = await http.get(
        Uri.parse('http://10.80.13.29:8000/home_page/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          // Successful login
          // You can handle the response here (e.g., store tokens, navigate to the next screen)
          print('Envelope count successful');
          print(jsonResponse);

          setState(() {
            envelopeCount = EnvelopeCount.fromJson(jsonResponse);
          });

          print(envelopeCount?.data?.completed);
        } else {
          // Handle invalid or empty JSON response
          print('Invalid JSON response');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        // Failed login
        // Handle error here (e.g., show an error message)
        print('Envelope count failed $response.statusCode');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
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
