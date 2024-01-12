import 'dart:convert';

import 'package:GreenSign/constants/app_constants.dart';
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

class Inbox extends StatefulWidget {
  int type = 0;
  Inbox (this.type);


  @override
  _InboxState createState() => _InboxState(type);


//make list view items
}

class _InboxState extends State<Inbox> {

  int _currentIndex = 1;
  String user_id_prefs = "";
  String auth_token = "";
  int box_index = 0;

  Envelope? envelope;

  int type = 0;

  bool isLoading = false;

  TextEditingController _searchController = TextEditingController();

  List<Envelope>? _filteredList = [];

  List<Envelope>? envelopes;

  MEnvelopeCount? menvelopeCount;

  String envelope_filter_name = "inbox";
  String envelope_type = "Inbox";
  String envelope_icon = ImageConstant.imgInbox;
  String from = "navigation";

  _InboxState(int type);

  void updateData(String env_filter,env_type,env_icon) {
    setState(() {
      envelope_filter_name = env_filter;
      envelope_type = env_type;
      envelope_icon = env_icon;
      print("dataFromChild $envelope_filter_name");
      //dismiss dialog
      Navigator.pop(context);
      getData("fromFilter",envelope_filter_name);
    });

  }

  @override
  void initState() {
    super.initState();
    print("Type $type");


    getData(from,envelope_filter_name);

    setState(() {
      // _foundedUsers = _users;
      _filteredList = envelopes;
    });
  }

  void getData(String from , String envelopeType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
    auth_token = prefs.getString('auth_token')!;
    box_index = prefs.getInt('dashboard_box_no')??0;

    print('user id from getData ${user_id_prefs}');

    if(from == "navigation"){

      switch(box_index){
        case 0:
          envelopeType = "inbox";
          envelope_type = "Inbox";
          envelope_icon = ImageConstant.imgInbox;
          break;
        case 1://Action required
          envelopeType = "inbox_action_required";
          envelope_type = "Action Required";
          envelope_icon = ImageConstant.imgExclamationCircle;
          break;
        case 2: //Waiting for others
          envelopeType = "inbox_waiting_for_others";
          envelope_type = "Waiting For Others";
          envelope_icon = ImageConstant.imgClock;
          break;
        case 3: //Expiring Soon
          envelopeType = "inbox_expiring_soon";
          envelope_type = "Expiring Soon";
          envelope_icon = ImageConstant.imgInfo;
          break;
        case 4: //Completed
          envelopeType = "completed_envelopes";
          envelope_type = "Completed";
          envelope_icon = ImageConstant.imgCheck;
          break;

      }

    }

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
  //         .where((envelope) => envelope.envelopeName?.toLowerCase().contains(searchText))
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
      String request_url = AppConstants.API_BASE_URL+"/$envelopeType/$userId";
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
              .showSnackBar(SnackBar(content: Text('Response incorrect$envelopeType')));
        }
      } else {
        print(response.statusCode);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$response.statusCode')));
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
        Uri.parse(AppConstants.API_BASE_URL+"/mange_count/$userId"),
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
