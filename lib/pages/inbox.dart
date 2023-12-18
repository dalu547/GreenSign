import 'dart:convert';

import 'package:flutter/material.dart';

import '../../model/envelope.dart';
import '../../model/profile.dart';
import 'package:http/http.dart' as http;

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();

//make list view items
}

class _InboxState extends State<Inbox> {
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
          .where((user) => user.first_name.toLowerCase().contains(search))
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
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 4),
            padding: const EdgeInsets.all(8),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              // User _user = _foundedUsers[index];
              return Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/action_required_icon.png'),
                        SizedBox(width: 20),
                        Text('Envelope Name'),
                        SizedBox(width: 20),
                        Text('Oct 05')
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [Text("Enveloper Name")],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: () {},
                          child: Text(
                            'Need to sign',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 100.0,
                          child: LinearProgressIndicator(
                            value: 0.5,
                            backgroundColor: Colors.grey,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text('1/3 done')
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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
