import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:GreenSign/pages/profilescreen_screen.dart';
import 'package:GreenSign/pages/settings_screen.dart';
import 'package:flutter/material.dart';

import '../../theme/app_decoration.dart';
import '../widgets/more_item_widget.dart';
import 'login_screen.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('More'),
          automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: _buildMoreList(context),
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
                          context, MaterialPageRoute(builder: (_) => ProfilescreenScreen("")));
                      break;
                    case 1:
                      //Settings
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => SettingsScreen()));
                      break;
                    case 2:
                      //Logout
                    // logoutAndNavigateToLogin(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => LoginScreen()));
                    break;
                      break;
                  }

                },
                child: MoreItemWidget(index: index,));
          },
        ));
  }

  void logoutAndNavigateToLogin(BuildContext context) {
    // Clear user authentication details or perform any necessary cleanup
    // For example, you might clear the user token or reset the authentication state

    // Navigate to the login screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

