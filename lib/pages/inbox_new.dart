import 'dart:convert';

import 'package:GreenSign/core/mock_responses.dart';
import 'package:GreenSign/core/utils/image_constant.dart';
import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:GreenSign/pages/envelopedetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/envelope.dart';
import '../../model/profile.dart';
import '../model/manage_envelope_count.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/emaillist_item_widget.dart';
import '../widgets/manageenvelope_screen.dart';
import '../widgets/manageenvelope_screen.dart';
import 'package:http/http.dart' as http;

class InboxNew extends StatefulWidget {
  int type = 0;
  InboxNew (this.type);


  @override
  _InboxState createState() => _InboxState(type);


//make list view items
}

class _InboxState extends State<InboxNew> {

  int _currentIndex = 1;
  String user_id_prefs = "";
  String auth_token = "";

  Envelope? envelope;

  int type = 0;

  bool isLoading = false;

  List<User> _users = [];
  TextEditingController _searchController = TextEditingController();

  List<Envelope>? _filteredList = [];

  List<Envelope>? envelopes;

  MEnvelopeCount? menvelopeCount;

  String envelope_filter_name = "inbox";
  String envelope_type = "Inbox";
  String envelope_icon = ImageConstant.imgInbox;

  _InboxState(int type);

  void updateData(String env_filter,env_type,env_icon) {
    setState(() {
      envelope_filter_name = env_filter;
      envelope_type = env_type;
      envelope_icon = env_icon;
      print("dataFromChild $envelope_filter_name");
      //dismiss dialog
      Navigator.pop(context);
      getData(envelope_filter_name);
    });

  }

  @override
  void initState() {
    super.initState();
    print("Type $type");

    getData(envelope_filter_name);

    setState(() {
      // _foundedUsers = _users;

    });
  }

  void getData(String envelopeType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
    auth_token = prefs.getString('auth_token')!;

    print('user id from getData ${user_id_prefs}');
    fetchInbox(user_id_prefs,envelopeType,auth_token);
    fetchManageEnvelopeCount(user_id_prefs,auth_token);

    setState(() {
      user_id_prefs = prefs.getString('user_id')!;
      print('user id from getPrefsData setState ${user_id_prefs}');
    });
  }

  // onSearch(String searchText) {
  //   setState(() {
  //     _filteredList = envelopes
  //         !.where((envelope) => envelope.envelopeName.toLowerCase().contains(searchText))
  //         .toList();
  //   });
  // }

  void onSearch(String searchText) {
    setState(() {
      _filteredList = envelopes
          ?.where((item) => item.envelopeName?.toLowerCase().contains(searchText.toLowerCase())??false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:   Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomImageView(
            imagePath: envelope_icon,
            height: 24.adaptSize,
            width: 24.adaptSize,
          ),
        ),
        title: Text(envelope_type),
        actions: [
          IconButton(
            onPressed: () {
              print('filter tap');
              // Show the custom dialog
              _showCustomDialog(context,callback: updateData); // ScaffoldMessenger.of(context)
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _searchController,
          //     onChanged: (value) {
          //       onSearch(value);
          //     },
          //     decoration: InputDecoration(
          //       labelText: 'Search',
          //       hintText: 'Search...',
          //       prefixIcon: Icon(Icons.search),
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(child: _buildEnvelopeList(context)),
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

  void _showCustomDialog(BuildContext context, {required void Function(String env_filter,String env_type,String env_icon) callback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ManageenvelopeScreen(
            menvelopeCount!,callback); // Your custom dialog widget
      },
    );
  }

  fetchInbox(String userId,String envelopeType,String auth_token) async {
    setState(() {
      isLoading = true;
    });

    try {
      String request_url = "http://10.80.13.29:8000/$envelopeType/$userId";
      print(request_url);
      final response = await http.get(
        Uri.parse(request_url),
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $auth_token'},
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
            _filteredList = envelopes;
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

  fetchManageEnvelopeCount(String userId,String auth_token) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.80.13.29:8000/mange_count/$userId'),
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $auth_token'},
      );

      // final response = MockResponses.manageEnvelopeCountResponse;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print(jsonResponse);
          setState(() {
            menvelopeCount = MEnvelopeCount.fromJson(jsonResponse);
            print(menvelopeCount?.data?.inbox);
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
