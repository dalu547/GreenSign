import 'dart:convert';

import 'package:GreenSign/core/mock_responses.dart';
import 'package:GreenSign/pages/envelopedetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/envelope.dart';
import '../../model/profile.dart';
import '../model/manage_envelope_count.dart';
import '../widgets/emaillist_item_widget.dart';
import '../widgets/manageenvelope_screen.dart';
import '../widgets/manageenvelope_screen.dart';
import 'package:http/http.dart' as http;

class InboxNew extends StatefulWidget {
  InboxNew(String s);

  @override
  _InboxState createState() => _InboxState();

//make list view items
}

class _InboxState extends State<InboxNew> {
  int _currentIndex = 1;
  String user_id_prefs = "";

  Envelope? envelope;

  bool isLoading = false;

  List<User> _users = [];

  List<User> _foundedUsers = [];
  List<Envelope>? envelopes;

  MEnvelopeCount? menvelopeCount;

  @override
  void initState() {
    super.initState();

    getData();
    setState(() {
      _foundedUsers = _users;
    });
  }

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
    print('user id from getData ${user_id_prefs}');
    fetchInbox(user_id_prefs);
    fetchManageEnvelopeCount(user_id_prefs);

    setState(() {
      user_id_prefs = prefs.getString('user_id')!;
      print('user id from getPrefsData setState ${user_id_prefs}');
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
          IconButton(
            onPressed: () {
              print('Search clicked');
              // Show the custom dialog
              _showCustomDialog(context); // ScaffoldMessenger.of(context)
              //     .showSnackBar(SnackBar(content: Text('Dialog text')));
            },
            icon: Icon(Icons.filter_list_alt),
          ),
          // Image.asset(
          //   'assets/images/filter_icon.png',
          // ),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              child: SingleChildScrollView(child: _buildEnvelopeList(context)),
            ),
          ),
          Container(
              child: Center(
            child: isLoading ? CircularProgressIndicator() : Text(''),
          ))
        ],
      ),
    );
  }

  Widget _buildEnvelopeList(BuildContext context) {
    if (envelopes?.isNotEmpty == true) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(height: 1);
          },
          itemCount: envelopes!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: EmaillistItemWidget(envelopes![index]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            EnvelopedetailsScreen(envelopes![index])));
              },
            );
          },
        ),
      );
    } else {
      return Offstage();
    }
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ManageenvelopeScreen(
            menvelopeCount!); // Your custom dialog widget
      },
    );
  }

  fetchInbox(String userId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.80.13.29:8000/inbox/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      // final response = MockResponses.homePageInboxResponse;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print(jsonResponse);
          Map<String, dynamic>? data = jsonResponse['data'];
          List<dynamic>? resultList = data?['result'];
          final envelopesList = resultList
              ?.map((approvalJson) => Envelope.fromJson(approvalJson))
              .toList();
          setState(() {
            envelopes = envelopesList;
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  fetchManageEnvelopeCount(String userId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.80.13.29:8000/mange_count/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      // final response = MockResponses.manageEnvelopeCountResponse;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print(jsonResponse);
          setState(() {
            menvelopeCount = MEnvelopeCount.fromJson(jsonResponse);
            print(menvelopeCount?.data.inbox);
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
