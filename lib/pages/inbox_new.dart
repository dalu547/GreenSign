import 'dart:convert';

import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../../model/envelope.dart';
import '../../model/user.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_decoration.dart';
import '../widgets/emaillist_item_widget.dart';
import 'envelopedetails_screen.dart';

class InboxNew extends StatefulWidget {
  InboxNew(String s);

  @override
  _InboxState createState() => _InboxState();

//make list view items
}

class _InboxState extends State<InboxNew> {
  int _currentIndex = 1;
  Envelope? envelope;

  bool isLoading = false;

  List<User> _users = [];

  List<User> _foundedUsers = [];

  @override
  void initState() {
    super.initState();

    fetchInbox("64cb5370930845c5c4b012c0");

    setState(() {
      _foundedUsers = _users;
    });
  }

  onSearch(String search) {
    setState(() {
      _foundedUsers = _users
          .where((user) => user.name.toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset('assets/images/inbox_icon.png'),
        title: Text('Inbox'),
        actions: [
          Image.asset('assets/images/filter_icon.png'),
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: _buildEnvelopeList(context),
        ),
      ),
    );
  }

  Widget _buildEnvelopeList(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        decoration:
            BoxDecoration(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(height: 1);
          },
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  // Handle item click here
                  print('Item clicked: $index');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EnvelopedetailsScreen()));
                },
                child: EmaillistItemWidget());
          },
        ));
  }

  fetchInbox(String user_id) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.80.13.29:8000/inbox/$user_id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          // Successful login
          // You can handle the response here (e.g., store tokens, navigate to the next screen)
          print('get inbox successful');
          print(jsonResponse);

          setState(() {
            envelope = Envelope.fromJson(jsonResponse);
          });

          print(envelope?.documents[0].documentName);
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
