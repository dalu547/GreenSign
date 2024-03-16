import 'dart:convert';

import 'package:DigiSign/constants/app_constants.dart';
import 'package:DigiSign/core/mock_responses.dart';
import 'package:DigiSign/core/utils/image_constant.dart';
import 'package:DigiSign/core/utils/size_utils.dart';
import 'package:DigiSign/pages/envelopedetails_screen.dart';
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

  InboxNew(this.type);

  @override
  _InboxState createState() => _InboxState(type);

//make list view items
}

class _InboxState extends State<InboxNew> {
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

  bool _responseReceived = false;


  _InboxState(int type);

  //This method will trigger if it is from dialog selection.
  void updateData(String env_filter, env_type, env_icon) {
    setState(() {
      envelope_filter_name = env_filter;
      envelope_type = env_type;
      envelope_icon = env_icon;
      print("dataFromChild $envelope_filter_name");
      //dismiss dialog
      Navigator.pop(context);
      getData("fromFilter", envelope_filter_name);
    });
  }

  @override
  void initState() {
    super.initState();
    print("Type $type");

    box_index = 0;
    getData(from, envelope_filter_name);

    setState(() {
      _filteredList = envelopes;
    });
  }

  void getData(String from, String envelopeType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
    auth_token = prefs.getString('auth_token')!;
    box_index = prefs.getInt('dashboard_box_no') ?? 0;
    print(box_index);

    print('user id from getData ${user_id_prefs}');

    if (from == "navigation") {
      switch (box_index) {
        case 0: //Inbox
          envelopeType = "inbox";
          envelope_type = "Inbox";
          envelope_icon = ImageConstant.imgInbox;
          break;
        case 1: //Action required
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

    fetchInbox(user_id_prefs, envelopeType, auth_token);
    fetchManageEnvelopeCount(user_id_prefs, auth_token);

    setState(() {
      user_id_prefs = prefs.getString('user_id')!;
      print('user id from getPrefsData setState ${user_id_prefs}');
    });
  }

  void onSearch(String searchText) {
    setState(() {
      _filteredList = envelopes
          ?.where((item) =>
              item.envelopeName
                  ?.toLowerCase()
                  .contains(searchText.toLowerCase()) ??
              false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
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
              if(_responseReceived){
                // Show the custom dialog
                _showCustomDialog(context,
                    callback: updateData);
              }else{
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Please wait data loading...')));
              }
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            // Adjust the value as needed
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                onSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by envelope name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: SingleChildScrollView(child: _buildEnvelopeList(context)),
            ),
          ),
          Container(
            child: Center(
              child: isLoading ? CircularProgressIndicator() : Text(''),
            ),
          ),
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
          itemCount: _filteredList!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: EmaillistItemWidget(_filteredList![index], envelope_type,envelope_icon),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            EnvelopedetailsScreen(_filteredList![index])));
              },
            );
          },
        ),
      );
    } else {
      return Offstage();
    }
  }

  void _showCustomDialog(BuildContext context,
      {required void Function(
              String env_filter, String env_type, String env_icon)
          callback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ManageenvelopeScreen(
            menvelopeCount!, callback); // Your custom dialog widget
      },
    );
  }

  fetchInbox(String userId, String envelopeType, String auth_token) async {
    setState(() {
      isLoading = true;
    });

    try {
      String request_url = AppConstants.API_BASE_URL + "/$envelopeType/$userId";
      print(request_url);
      final response = await http.get(
        Uri.parse(request_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth_token'
        },
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
          print(_filteredList?.length);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Response incorrect$envelopeType')));
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

  fetchManageEnvelopeCount(String userId, String auth_token) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(AppConstants.API_BASE_URL + "/mange_count/$userId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth_token'
        },
      );

      // final response = MockResponses.manageEnvelopeCountResponse;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print(jsonResponse);
          setState(() {
            menvelopeCount = MEnvelopeCount.fromJson(jsonResponse);
            _responseReceived = true;
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
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
