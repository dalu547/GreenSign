import 'dart:convert';

import 'package:GreenSign/core/utils/image_constant.dart';
import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:GreenSign/widgets/history_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/envelope.dart';
import '../../model/profile.dart';
import '../constants/app_constants.dart';
import '../model/EnvelopeHistory.dart';
import '../model/manage_envelope_count.dart';

class EnvelopesHistoryScreen extends StatefulWidget {
  String? env_id = "";

  EnvelopesHistoryScreen(this.env_id);

  @override
  _EnvelopesHistoryState createState() => _EnvelopesHistoryState(env_id);

//make list view items
}

class _EnvelopesHistoryState extends State<EnvelopesHistoryScreen> {
  String user_id_prefs = "";
  String auth_token = "";

  EnvelopeHistory? envelopeHistory;

  bool isLoading = false;

  TextEditingController _searchController = TextEditingController();

  List<Envelope>? _filteredList = [];

  List<Envelope>? envelopes;

  String? env_id = "";

  _EnvelopesHistoryState(this.env_id);

  @override
  void initState() {
    super.initState();
    print(env_id);

    getData(env_id!);

    setState(() {
      // _foundedUsers = _users;
    });
  }

  void getData(String envelopeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
    auth_token = prefs.getString('auth_token')!;

    print('user id from getData ${user_id_prefs}');
    print('envelopeId $envelopeId');
    fetchHistory(envelopeId, auth_token);

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
          ?.where((item) => item.envelopeName
              ?.toLowerCase()
              .contains(searchText.toLowerCase())??false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/digisign_title_logo_small.png'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Envelope: "+envelopeHistory!.data!.result!.envelopeName!??"",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Activities: ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildActivityList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    if (envelopeHistory?.data?.result?.activites?.isNotEmpty == true) {
      return Container(
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(height: 1);
          },
          itemCount: envelopeHistory!.data!.result!.activites!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: HistorylistItemWidget(
                  envelopeHistory!.data!.result!.activites![index]),
              onTap: () {},
            );
          },
        ),
      );
    } else {
      return Offstage();
    }
  }

  fetchHistory(String env_id, String auth_token) async {
    setState(() {
      isLoading = true;
    });

    try {
      String request_url = AppConstants.API_BASE_URL+"/env_history/$env_id";
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

          final envelopeHistoryRes = EnvelopeHistory.fromJson(jsonResponse);
          print(envelopeHistoryRes.data?.result?.activites
              ?.elementAt(0)
              .timestamp);

          setState(() {
            envelopeHistory = envelopeHistoryRes;
            isLoading = false;
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
}
