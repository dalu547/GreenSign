import 'dart:convert';

import 'package:DigiSign/constants/app_constants.dart';
import 'package:DigiSign/core/mock_responses.dart';
import 'package:DigiSign/core/utils/size_utils.dart';
import 'package:DigiSign/model/envelope.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/envelope_count.dart';
import '../core/utils/image_constant.dart';
import '../widgets/emaillist_item_widget.dart';
import '../widgets/userprofile_item_widget.dart';
import 'envelopedetails_screen.dart';
import 'package:http/http.dart' as http;

class DashBoardNew extends StatefulWidget {
  String user_id;

  final Function(int) onTapManageTab;

  DashBoardNew(this.user_id, this.onTapManageTab);

  @override
  State<StatefulWidget> createState() {
    return _DashBoardState(this.user_id);
  }
}

class _DashBoardState extends State<DashBoardNew> {
  String user_id;
  String user_id_prefs = "";
  String auth_token = "";

  _DashBoardState(this.user_id);

  EnvelopeCount? envelopeCount;
  List<Envelope>? envelopes;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getData();
    // user_id_prefs = "64cb5370930845c5c4b012c0";
    print('user id from prefs in dashboard ${user_id_prefs}');
  }

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("dashboard_box_no", 0);
    user_id_prefs = prefs.getString('user_id')!;
    auth_token = prefs.getString('auth_token')!;
    print('user id from getPrefsData ${user_id_prefs}');
    fetchEnvelopeCount(user_id_prefs,auth_token);
    fetchActionRequiredEnvelopes(user_id_prefs,auth_token);

    setState(() {
      user_id_prefs = prefs.getString('user_id')!;
      print('user id from getPrefsData setState ${user_id_prefs}');
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
        child: Stack(
          children: [
            Container(
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
            Container(
                child: Center(
                  child: isLoading ? CircularProgressIndicator() : Text(''),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
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
              title: EmaillistItemWidget(envelopes![index],"Action Required",ImageConstant.imgExclamationCircle,
              ),
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
              return UserprofileItemWidget(
                  envelopeCount, index, widget.onTapManageTab);
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

  fetchEnvelopeCount(String userId,String auth_token) async {
    print('user id from fetchEnvelopeCount ${userId}');

    setState(() {
      isLoading = true;
    });

    try {

      final response = await http.get(
        Uri.parse(AppConstants.API_BASE_URL+"/home_page/$userId"),
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $auth_token'},
      );

      // final response = MockResponses.homePageCountResponse;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print('Envelope count successful');
          print(jsonResponse);
          setState(() {
            envelopeCount = EnvelopeCount.fromJson(jsonResponse);
          });
          print(envelopeCount?.data?.completed);
        } else {
          print('Invalid JSON response');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
        }
      } else {
        print('Envelope count failed $response.statusCode');
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

  fetchActionRequiredEnvelopes(String userId,String auth_token) async {
    print('user id from fetchInbox ${userId}');

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(AppConstants.API_BASE_URL+"/inbox_action_required/$userId"),
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $auth_token'},
      );

      // final response = MockResponses.homePageInboxResponse;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print('Action required successful');
          print(jsonResponse);
          Map<String, dynamic>? data = jsonResponse['data'];
          List<dynamic>? resultList = data?['result'];
          final envelopesList = resultList
              ?.map((approvalJson) => Envelope.fromJson(approvalJson))
              .toList();
          setState(() {
            envelopes = envelopesList;
          });
          print(envelopeCount?.data?.completed);
        } else {
          print('Invalid JSON response');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
        }
      } else {
        print('Envelope count failed $response.statusCode');
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
