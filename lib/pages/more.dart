import 'package:DigiSign/core/utils/size_utils.dart';
import 'package:DigiSign/pages/long_signatures_screen.dart';
import 'package:DigiSign/pages/my_signatures_screen.dart';
import 'package:DigiSign/pages/profilescreen_screen.dart';
import 'package:DigiSign/pages/settings_screen.dart';
import 'package:flutter/material.dart';

import '../../theme/app_decoration.dart';
import '../widgets/more_item_widget.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';


class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {

  String? _version;
  String? _buildNumber;
  String? _appName;
  String? _packageName;

  @override
  void initState() {
    super.initState();

    _getAppVersion();

  }

  void _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    final appName = packageInfo.appName;
    final packageName = packageInfo.packageName;

    setState(() {
      _version = version;
      _buildNumber = buildNumber;
      _appName = appName;
      _packageName = packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('More'),
          automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: _buildMoreList(context),
          ),
          Text('Version $_version ($_buildNumber)'),
        ],
      ),
    );
  }

  Widget _buildMoreList(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        decoration:
            BoxDecoration(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(height: 2);
          },
          itemCount: 3,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  // Handle item click here
                  print('Item clicked: $index');

                  switch(index){
                    case 0:
                      //My Profile
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => MySignaturesScreen("")));
                      break;
                    case 1:
                      //Settings
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => SettingsScreen()));
                      break;
                    case 2:
                      //Logout
                    logoutAndNavigateToLogin(context);
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (_) => LoginScreen()));
                    break;
                      break;
                  }

                },
                child: MoreItemWidget(index: index,));
          },
        ));
  }

 logoutAndNavigateToLogin(BuildContext context) async {
    // Clear user authentication details or perform any necessary cleanup
    // For example, you might clear the user token or reset the authentication state

    // Navigate to the login screen
     SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_logged_in", false);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginScreen()),
    // );

     Navigator.of(context).pushAndRemoveUntil(
       MaterialPageRoute(builder: (context) => LoginScreen()),
           (Route<dynamic> route) => false,
     );
  }
}

