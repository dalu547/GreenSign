import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';


import 'package:DigiSign/constants/app_constants.dart';
import 'package:DigiSign/model/profile.dart';
import 'package:DigiSign/pages/camera_screen.dart';
import 'package:DigiSign/pages/image_picker_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_image_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import 'package:http/http.dart' as http;

import '../widgets/mobile_image_converter.dart';

class ProfilescreenScreen extends StatefulWidget {
  String user_id;

  ProfilescreenScreen(this.user_id);

  @override
  State<StatefulWidget> createState() {
    return _ProfilescreenScreenState(this.user_id);
  }
}

class _ProfilescreenScreenState extends State<ProfilescreenScreen> {
  _ProfilescreenScreenState(String user_id);

  bool isLoading = false;
  String user_id_prefs = "";
  String auth_token = "";

  Profile? profile;

  TextEditingController profileNameController = TextEditingController();

  bool _isSigned = false;
  late bool _isWebOrDesktop;
  double _minWidth = 1.0;
  double _maxWidth = 4.0;
  late Color _strokeColor = const Color.fromRGBO(0, 0, 0, 1);
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  late Uint8List _signatureData;
  Color currentPaletteColor = const Color.fromRGBO(0, 116, 227, 1);



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
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: appTheme.gray5001,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Profile"),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(height: 16.v),
                    // CustomImageView(
                    //   imagePath: ImageConstant.imgProfilepic21,
                    //   height: 88.adaptSize,
                    //   width: 88.adaptSize,
                    //   radius: BorderRadius.circular(
                    //     44.h,
                    //   ),
                    // ),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[200],
                      child: CachedNetworkImage(
                        imageUrl: profile?.data?.user?.profile_image != null
                            ? profile!.data!.user!.profile_image! + '?timestamp=${DateTime.now().millisecondsSinceEpoch}'
                            : '',
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8.v),
                    // Text(
                    //   "Edit",
                    //   style: CustomTextStyles.bodyMediumPrimary,
                    // ),
                    SizedBox(height: 25.v),
                    // _buildUploadOptions(context),
                    SizedBox(height: 16.v),
                    _buildCardWithBorder(
                      context,
                      mobileNo: profile?.data?.user?.first_name ?? "",
                      value: profile?.data?.user?.last_name ?? "",
                      company: profile?.data?.user?.email_address ?? "",
                      deskNumber: "**********",
                      address: "**********",
                    ),
                    SizedBox(height: 24.v),
                    _buildCardWithBorder(
                      context,
                      mobileNo: profile?.data?.user?.mobile ?? "",
                      value: profile?.data?.user?.role_name ?? "",
                      company: profile?.data!.user?.company ?? "",
                      deskNumber: profile?.data!.user?.desk_number ?? "",
                      address: profile?.data!.user?.address ?? "",
                    ),
                    SizedBox(height: 5.v),
                  ],
                ),
              ),
            ],
          ))),
    );
  }

  /// Section Widget
  Widget _buildUploadOptions(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.v),
          // Text(
          //   profile!.data.user.first_name,
          //   style: theme.textTheme.displayLarge,
          // ),
          CachedNetworkImage(
            imageUrl: profile?.data?.user?.digital_signature ?? "",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(height: 5.v),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildCardWithBorder(
    BuildContext context, {
    required String mobileNo,
    required String value,
    required String company,
    required String deskNumber,
    required String address,
  }) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 11.v),
      decoration: AppDecoration.outlineGray400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mobileNo,
                  style: CustomTextStyles.bodyLarge_1.copyWith(
                    color: appTheme.black900,
                  ),
                ),
                SizedBox(height: 11.v),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 12.v),
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: CustomTextStyles.bodyLarge_1.copyWith(
                    color: appTheme.black900,
                  ),
                ),
                SizedBox(height: 9.v),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 12.v),
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: CustomTextStyles.bodyLargeGray80099_1.copyWith(
                    color: appTheme.gray80099.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 9.v),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 11.v),
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deskNumber,
                  style: CustomTextStyles.bodyLargeGray80099_1.copyWith(
                    color: appTheme.gray80099.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 11.v),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 11.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                address,
                style: CustomTextStyles.bodyLargeGray80099_1.copyWith(
                  color: appTheme.gray80099.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  fetchProfileData(String userId, String auth_token) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(AppConstants.API_BASE_URL+"/user/$userId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $auth_token'
        },
      );

      // final response = MockResponses.profileResponse;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print('profile successful');
          print(jsonResponse);
          setState(() {
            profile = Profile.fromJson(jsonResponse);
          });
        } else {
          print('Invalid JSON response');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Some thing went wrong')));
        }
      } else {
        print('Profile failed $response.statusCode');
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
