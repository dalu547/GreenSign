import 'dart:convert';

import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/user_controller.dart';
import '../../model/envelope_count.dart';
import '../widgets/emaillist_item_widget.dart';
import '../widgets/userprofile_item_widget.dart';
import 'inbox.dart';

class DashBoardNew extends StatefulWidget {
  String user_id;

  DashBoardNew(this.user_id);

  // @override
  // _HomeScreenState createState() => _HomeScreenState();

  @override
  State<StatefulWidget> createState() {
    return _DashBoardState(this.user_id);
  }
}

class _DashBoardState extends State<DashBoardNew> {
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
    user_id_prefs = "64cb5370930845c5c4b012c0";
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/digisign_title_logo_small.png'),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0),
              end: Alignment(0.5, 1),
              colors: [Colors.deepPurple, Colors.blue],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildBoxes(context, envelopeCount),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Recent Activities",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: 361,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _buildRecentActivityList(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 1);
        },
        itemCount: 40,
        itemBuilder: (context, index) {
          // Replace the following line with your actual widget.
          return ListTile(
            title: EmaillistItemWidget(),
          );
        },
      ),
    );
  }

  Widget _buildBoxes(BuildContext context, EnvelopeCount? envelopeCount) {
    return Expanded(
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 109.v,
                crossAxisCount: 2,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.h),
            physics: BouncingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return UserprofileItemWidget(envelopeCount);
            }));
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

          print(envelopeCount?.data.completed);
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
