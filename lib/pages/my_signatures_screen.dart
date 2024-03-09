import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:DigiSign/core/utils/size_utils.dart';
import 'package:DigiSign/pages/initial_signatures_screen.dart';
import 'package:DigiSign/pages/long_signatures_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import '../core/utils/image_constant.dart';
import '../model/profile.dart';
import '../theme/app_decoration.dart';
import '../theme/theme_helper.dart';
import '../widgets/custom_image_view.dart';
import 'camera_screen.dart';
import 'image_picker_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:http/http.dart' as http;

import '../widgets/mobile_image_converter.dart';

class MySignaturesScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MySignaturesScreenState();
  }
}

class _MySignaturesScreenState extends State<MySignaturesScreen> {
  _MySignaturesScreenState();

  bool isLoading = false;
  String user_id_prefs = "";
  String auth_token = "";

  bool _isSigned = false;
  late bool _isWebOrDesktop;
  double _minWidth = 1.0;
  double _maxWidth = 4.0;
  late Color _strokeColor = const Color.fromRGBO(0, 0, 0, 1);
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  late Uint8List _signatureData;
  Color currentPaletteColor = const Color.fromRGBO(0, 116, 227, 1);

  TextEditingController swathiController = TextEditingController();

  Profile? profile;

  @override
  void initState() {
    super.initState();

    _isWebOrDesktop = defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        kIsWeb;

    getData();
  }

  bool _handleOnDrawStart() {
    _isSigned = true;
    return false;
  }

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
    auth_token = prefs.getString('auth_token')!;

    print('user id from getData ${user_id_prefs}');
    fetchProfileData(user_id_prefs, auth_token);

    setState(() {
      user_id_prefs = prefs.getString('user_id')!;
      print('user id from getPrefsData setState ${user_id_prefs}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('My Signatures'),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: 361.h,
            margin: EdgeInsets.only(
              left: 16.h,
              top: 16.v,
              right: 16.h,
            ),
            decoration: AppDecoration.fillWhiteA.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFrameOne(context),
                SizedBox(height: 16.v),
                _buildFrameTwo(context),
                SizedBox(height: 16.v),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrameOne(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 15.v),
      decoration: AppDecoration.outlineIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CustomImageView(
          //   imagePath: ImageConstant.imgUserWhiteA700,
          //   height: 20.v,
          //   width: 16.h,
          //   margin: EdgeInsets.only(bottom: 146.v),
          // ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.h,
                bottom: 8.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Long Signature",
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 81.v,
                    width: 297.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 85.v,
                            width: 297.h,
                            decoration: BoxDecoration(
                              color: appTheme.whiteA700,
                              borderRadius: BorderRadius.circular(
                                4.h,
                              ),
                              border: Border.all(
                                color: appTheme.indigo50,
                                width: 1.h,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.h),
                            child: CachedNetworkImage(
                              imageUrl: profile?.data?.user?.digital_signature != null
                                  ? profile!.data!.user!.digital_signature! + '?timestamp=${DateTime.now().millisecondsSinceEpoch}' : '',
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.v),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        // Add your button onPressed logic here
                        print('Button clicked');

                        Navigator.pop(context);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => LongSignaturesScreen()));
                      },

                      child: Text(
                        'Edit LongSignature',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameTwo(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 15.v),
      decoration: AppDecoration.outlineIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CustomImageView(
          //   imagePath: ImageConstant.imgUserWhiteA700,
          //   height: 20.v,
          //   width: 16.h,
          //   margin: EdgeInsets.only(bottom: 146.v),
          // ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.h,
                bottom: 8.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Initial",
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 81.v,
                    width: 297.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 72.v,
                            width: 297.h,
                            decoration: BoxDecoration(
                              color: appTheme.whiteA700,
                              borderRadius: BorderRadius.circular(
                                4.h,
                              ),
                              border: Border.all(
                                color: appTheme.indigo50,
                                width: 1.h,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.h),
                            child: CachedNetworkImage(
                              imageUrl: profile?.data?.user?.initial != null
                                  ? profile!.data!.user!.initial! + '?timestamp=${DateTime.now().millisecondsSinceEpoch}'
                                  : '',
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.v),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        // Add your button onPressed logic here
                        print('Button clicked');
                        Navigator.pop(context);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => InitialSignaturesScreen()));
                      },
                      child: Text(
                        'Edit Initial',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  fetchProfileData(String userId, String auth_token) async {
    print('fetch profile in my signatures screen');
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(AppConstants.API_BASE_URL + "/user/$userId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth_token'
        },
      );

      // final response = MockResponses.profileResponse;
      print('Response Body: ${await response.body}');


      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print('profile successful');
          print(jsonResponse);

          setState(() {
            profile = Profile.fromJson(jsonResponse);
            print(profile?.data?.user?.long_signature_1);
          });

        } else {
          print('Invalid JSON response');
          ScaffoldMessenger.of(context as BuildContext)
              .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
        }
      } else {
        print('Profile failed $response.statusCode');
        ScaffoldMessenger.of(context as BuildContext)
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
