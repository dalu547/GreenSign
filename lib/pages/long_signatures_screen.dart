import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:DigiSign/core/utils/size_utils.dart';
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
import 'my_signatures_screen.dart';



class LongSignaturesScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LongSignaturesScreenState();
  }

}

class _LongSignaturesScreenState extends State<LongSignaturesScreen> {

  late Profile profile;

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

  int _selectedOption = 1;

  String _ls1ImagePath = ImageConstant.imgUncheckedSignatutre;
  String _ls2ImagePath = ImageConstant.imgUncheckedSignatutre;
  String _ls3ImagePath = ImageConstant.imgUncheckedSignatutre;
  String _ls4ImagePath = ImageConstant.imgUncheckedSignatutre;

  bool isLS1Selected = false;
  bool isLS2Selected = false;
  bool isLS3Selected = false;
  bool isLS4Selected = false;

  String  selected_sign_type = "";
  String  selected_sign_path = "";

  @override
  void initState() {
    super.initState();

    _isWebOrDesktop = defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        kIsWeb;

    profile = Profile(status: '', data: null); // Initialize profile here

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
          title: Text('Long Signatures'),
          leading: BackButton(
            onPressed: (){

              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MySignaturesScreen()));

            },
          ),
          actions: [
            Container(
              child: MaterialButton(
                onPressed: () {

                  if(!selected_sign_type.isEmpty){
                    if(!selected_sign_path.isEmpty){
                      updateDefaultSignature(auth_token, user_id_prefs, true, selected_sign_type,context);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Signature should not be empty.')));
                    }
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Atleast one signature should be selected.')));
                  }

                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
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
                _buildFrameThree(context),
                SizedBox(height: 16.v),
                _buildFrameFour(context),
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
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 16.v),
      decoration: AppDecoration.outlineIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                isLS1Selected = true;
                isLS2Selected = false;
                isLS3Selected = false;
                isLS4Selected = false;
                _ls1ImagePath = ImageConstant.imgCheckedSignature;
                _ls2ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls3ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls4ImagePath = ImageConstant.imgUncheckedSignatutre;

                selected_sign_type = "longSignature1";
                selected_sign_path = profile.data?.user?.long_signature_1 ?? "";

              });
            },
            child: CustomImageView(
              imagePath: _ls1ImagePath,
              height: 20.v,
              width: 20.h,
              margin: EdgeInsets.only(bottom: 146.v),
            ),
          ),
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
                    "Long Signature 1",
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 80.v,
                    width: 300.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100.v,
                            width: 300.h,
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
                            padding: EdgeInsets.fromLTRB(4.h, 4.v, 4.h, 4.v),
                            child: CachedNetworkImage(
                              imageUrl: profile?.data?.user?.long_signature_1 != null
                                  ? profile!.data!.user!.long_signature_1! + '?timestamp=${DateTime.now().millisecondsSinceEpoch}'
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
                  SizedBox(height: 24.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print("Camera");
                          uploadSignatureFromCamera(1,isLS1Selected,"longSignature1");
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgInfoPrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Capture",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Digital pad");
                          drawSignature(1,isLS1Selected,"longSignature1");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgClosePrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Draw",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Upload");

                          uploadSignatureFromGallery(1,isLS1Selected,"longSignature1");

                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgIconPrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Upload",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 16.v),
      decoration: AppDecoration.outlineIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              print("Long Signature one clicked");
              setState(() {
                isLS1Selected = false;
                isLS2Selected = true;
                isLS3Selected = false;
                isLS4Selected = false;
                _ls1ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls2ImagePath = ImageConstant.imgCheckedSignature;
                _ls3ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls4ImagePath = ImageConstant.imgUncheckedSignatutre;
                selected_sign_type = "longSignature2";

                selected_sign_path = profile.data?.user?.long_signature_2 ?? "";


              });
            },
            child: CustomImageView(
              imagePath: _ls2ImagePath,
              height: 20.v,
              width: 20.h,
              margin: EdgeInsets.only(bottom: 146.v),
            ),
          ),
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
                    "Long Signature 2",
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 80.v,
                    width: 300.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100.v,
                            width: 300.h,
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
                            padding: EdgeInsets.fromLTRB(4.h, 4.v, 4.h, 4.v),
                            child: CachedNetworkImage(
                              imageUrl: profile?.data?.user?.long_signature_2 != null
                                  ? profile!.data!.user!.long_signature_2! + '?timestamp=${DateTime.now().millisecondsSinceEpoch}'
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
                  SizedBox(height: 24.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print("Camera");
                          uploadSignatureFromCamera(2,isLS2Selected,"longSignature2");
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgInfoPrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Capture",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Digital pad");
                          drawSignature(2,isLS2Selected,"longSignature2");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgClosePrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Draw",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Upload");
                          uploadSignatureFromGallery(2,isLS2Selected,"longSignature2");

                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgIconPrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Upload",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFrameThree(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 16.v),
      decoration: AppDecoration.outlineIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              print("Long Signature one clicked");
              setState(() {
                isLS1Selected = false;
                isLS2Selected = false;
                isLS3Selected = true;
                isLS4Selected = false;
                _ls1ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls2ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls3ImagePath = ImageConstant.imgCheckedSignature;
                _ls4ImagePath = ImageConstant.imgUncheckedSignatutre;
                selected_sign_type = "longSignature3";

                selected_sign_path = profile.data?.user?.long_signature_3 ?? "";


              });
            },
            child: CustomImageView(
              imagePath: _ls3ImagePath,
              height: 20.v,
              width: 20.h,
              margin: EdgeInsets.only(bottom: 146.v),
            ),
          ),
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
                    "Long Signature 3",
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 80.v,
                    width: 300.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100.v,
                            width: 300.h,
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
                            padding: EdgeInsets.fromLTRB(4.h, 4.v, 4.h, 4.v),
                            child: CachedNetworkImage(
                              imageUrl: profile?.data?.user?.long_signature_3 != null
                                  ? profile!.data!.user!.long_signature_3! + '?timestamp=${DateTime.now().millisecondsSinceEpoch}'
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
                  SizedBox(height: 24.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print("Camera");
                          uploadSignatureFromCamera(3,isLS3Selected,"longSignature3");
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgInfoPrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Capture",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Digital pad");
                          drawSignature(3,isLS3Selected,"longSignature3");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgClosePrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Draw",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Upload");
                          uploadSignatureFromGallery(3,isLS3Selected,"longSignature3");
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgIconPrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Upload",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFrameFour(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 16.v),
      decoration: AppDecoration.outlineIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              print("Long Signature one clicked");
              setState(() {
                isLS1Selected = false;
                isLS2Selected = false;
                isLS3Selected = false;
                isLS4Selected = true;
                _ls1ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls2ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls3ImagePath = ImageConstant.imgUncheckedSignatutre;
                _ls4ImagePath = ImageConstant.imgCheckedSignature;
                selected_sign_type = "longSignature4";

                selected_sign_path = profile.data?.user?.long_signature_4 ?? "";


              });
            },
            child: CustomImageView(
              imagePath: _ls4ImagePath,
              height: 20.v,
              width: 20.h,
              margin: EdgeInsets.only(bottom: 146.v),
            ),
          ),
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
                    "Long Signature 4",
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 80.v,
                    width: 300.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100.v,
                            width: 300.h,
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
                            padding: EdgeInsets.fromLTRB(4.h, 4.v, 4.h, 4.v),
                            child: CachedNetworkImage(
                              imageUrl: profile?.data?.user?.long_signature_4 != null
                                  ? profile!.data!.user!.long_signature_4! + '?timestamp=${DateTime.now().millisecondsSinceEpoch}'
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
                  SizedBox(height: 24.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print("Camera");
                          uploadSignatureFromCamera(4,isLS4Selected,"longSignature4");
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgInfoPrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Capture",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Digital pad");
                          drawSignature(4,isLS4Selected,"longSignature4");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgClosePrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Draw",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Upload");
                          uploadSignatureFromGallery(4,isLS4Selected,"longSignature4");
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 4.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 6.v,
                          ),
                          decoration: AppDecoration.fillGray200.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgIconPrimary,
                                  height: 18.adaptSize,
                                  width: 18.adaptSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.h),
                                  child: Text(
                                    "Upload",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void uploadSignatureFromGallery(int sign_num,bool isDefault,String sign_type) {
    // Navigator.push(context as BuildContext, MaterialPageRoute(builder: (_) => ImagePickerScreen(isDefault,sign_type)));

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ImagePickerScreen(isDefault,sign_type)),
    // ).then((isupdate) {
    //   if(isupdate){
    //     print("profile call after gallery update");
    //     // Handle updated data here
    //     fetchProfileData(user_id_prefs, auth_token);
    //   }
    // });

    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ImagePickerScreen(isDefault,sign_type,"long_signature")));

  }

  void drawSignature(int sign_num,bool isDefault,String sign_type) {

    _showPopup(isDefault,sign_type);

    // Navigator.push(context, MaterialPageRoute(builder: (_) => SignaturePage()));
  }

  Future<void> uploadSignatureFromCamera(int sign_num,bool isDefault,String sign_type) async {

    // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    Navigator.push(context, MaterialPageRoute(builder: (_) => TakePictureScreen(firstCamera,isDefault,sign_type,"long_signature")));

  }

  Color? _getTextColor() => Colors.grey[700];
  Color? _getBorderColor() => Colors.grey[350];

  //Signature Pad.
  void _showPopup(bool isDefault,String sign_type) {
    _isSigned = false;

    // if (_isWebOrDesktop) {
    //   _backgroundColor = _isDark ? model.webBackgroundColor : Colors.white;
    // }

    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            final Color? backgroundColor = Colors.white;
            final Color textColor = Colors.black87;

            return AlertDialog(
              insetPadding: _isWebOrDesktop
                  ? const EdgeInsets.fromLTRB(10, 10, 15, 10)
                  : const EdgeInsets.all(12),
              backgroundColor: backgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Draw your signature',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                  InkWell(
                    //ignore: sdk_version_set_literal
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.clear,
                        color: const Color.fromRGBO(0, 0, 0, 0.54),
                        size: 24.0),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 306
                      ? MediaQuery.of(context).size.width
                      : 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width < 306
                            ? MediaQuery.of(context).size.width
                            : 450,
                        height: 172,
                        decoration: BoxDecoration(
                          border: Border.all(color: _getBorderColor()!),
                        ),
                        child: SfSignaturePad(
                            minimumStrokeWidth: _minWidth,
                            maximumStrokeWidth: _maxWidth,
                            strokeColor: _strokeColor,
                            backgroundColor: Colors.white,
                            onDrawStart: _handleOnDrawStart,
                            key: _signaturePadKey),
                      ),
                      const SizedBox(height: 24),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Text(
                      //       'Pen Color',
                      //       style: TextStyle(
                      //           color: textColor,
                      //           fontWeight: FontWeight.w400,
                      //           fontFamily: 'Roboto-Regular'),
                      //     ),
                      //     // SizedBox(
                      //     //   width: 124,
                      //     //   child: Row(
                      //     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     //     children: _addStrokeColorPalettes(setState),
                      //     //   ),
                      //     // )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              actionsPadding: const EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: <Widget>[
                TextButton(
                  onPressed: _handleClearButtonPressed,
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(currentPaletteColor),
                  ),
                  child: const Text(
                    'CLEAR',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto-Medium'),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    _handleSaveButtonPressed(isDefault,sign_type);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(currentPaletteColor),
                  ),
                  child: const Text('SAVE',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                )
              ],
            );
          },
        );
      },
    );
  }


  void _handleClearButtonPressed() {
    _signaturePadKey.currentState!.clear();
    _isSigned = false;
  }

  Future<void> _handleSaveButtonPressed(bool isDefault,String sign_type) async {
    late Uint8List data;

    if (kIsWeb) {
      final RenderSignaturePad renderSignaturePad =
      _signaturePadKey.currentState!.context.findRenderObject()!
      as RenderSignaturePad;
      data =
      await ImageConverter.toImage(renderSignaturePad: renderSignaturePad);
    } else {
      final ui.Image imageData =
      await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final ByteData? bytes =
      await imageData.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        data = bytes.buffer.asUint8List();
      }
    }

    setState(
          () {
        _signatureData = data;
      },
    );

    // Write the Uint8List to a file
    File file = await writeBytesToFile(data, 'example_image.jpg');

    // Use the created file as needed
    print('File path: ${file.path}');

    uploadImage(file, auth_token, user_id_prefs,isDefault,sign_type);

  }

  Future<File> writeBytesToFile(Uint8List bytes, String fileName) async {
    // Get the application's document directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;

    // Create the file path
    final String filePath = '$appDocPath/$fileName';

    // Write the bytes to the file
    await File(filePath).writeAsBytes(bytes);

    return File(filePath);
  }

  //Signature pad upload.
  Future<void> uploadImage(File imageFile,String auth_token,String user_id,bool is_default,String sign_type) async {
    // Replace the URL with your server endpoint
    final String url = AppConstants.API_BASE_URL+"/upload_sign_path_mobile";

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    Map<String,String> headers= {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth_token'
    };

    // Add the image file to the request
    var fileStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('file', fileStream, length, filename: 'image.jpg');

    request.files.add(multipartFile);
    request.headers.addAll(headers);

    // You can add additional fields to the request if needed
    request.fields['user_id'] = user_id;
    request.fields['is_default'] = is_default.toString();
    request.fields['sign_type'] = sign_type;


    print('URL: $url');
    print('Headers: $headers');
    print('Image File: $imageFile');
    print('user_id: $user_id');
    print('is_default: $is_default');
    print('sign_type: $sign_type');

    // Send the request
    try {
      final response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Signature draw successfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature updated successfully')));

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LongSignaturesScreen()));

      } else {
        print('Failed to signature draw. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature failed')));
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }


  fetchProfileData(String userId, String auth_token) async {
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

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse is Map<String, dynamic>) {
          print('profile successful');
          print(jsonResponse);
          setState(() {
            profile = Profile.fromJson(jsonResponse);
            print(profile.data?.user?.digital_signature);
            setDefaultSignature(profile);

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


  void setDefaultSignature(Profile profile) {

    if(profile.data?.user?.digital_signature == profile.data?.user?.long_signature_1){

      _ls1ImagePath = ImageConstant.imgCheckedSignature;
      _ls2ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls3ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls4ImagePath = ImageConstant.imgUncheckedSignatutre;

      isLS1Selected = true;
      isLS2Selected = false;
      isLS3Selected = false;
      isLS4Selected = false;

      selected_sign_type = "longSignature1";
      selected_sign_path = profile.data?.user?.long_signature_1 ?? "";


    }else if(profile.data?.user?.digital_signature == profile.data?.user?.long_signature_2){

      _ls1ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls2ImagePath = ImageConstant.imgCheckedSignature;
      _ls3ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls4ImagePath = ImageConstant.imgUncheckedSignatutre;

      isLS1Selected = false;
      isLS2Selected = true;
      isLS3Selected = false;
      isLS4Selected = false;

      selected_sign_type = "longSignature2";
      selected_sign_path = profile.data?.user?.long_signature_2 ?? "";



    }else if(profile.data?.user?.digital_signature == profile.data?.user?.long_signature_3){

      _ls1ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls2ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls3ImagePath = ImageConstant.imgCheckedSignature;
      _ls4ImagePath = ImageConstant.imgUncheckedSignatutre;

      isLS1Selected = false;
      isLS2Selected = false;
      isLS3Selected = true;
      isLS4Selected = false;

      selected_sign_type = "longSignature3";
      selected_sign_path = profile.data?.user?.long_signature_3 ?? "";



    }else if(profile.data?.user?.digital_signature == profile.data?.user?.long_signature_4){

      _ls1ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls2ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls3ImagePath = ImageConstant.imgUncheckedSignatutre;
      _ls4ImagePath = ImageConstant.imgCheckedSignature;

      isLS1Selected = false;
      isLS2Selected = false;
      isLS3Selected = false;
      isLS4Selected = true;

      selected_sign_type = "longSignature4";

      selected_sign_path = profile.data?.user?.long_signature_4 ?? "";


    }

  }

  //Signature pad upload.
  Future<void> updateDefaultSignature(String auth_token, String user_id,
      bool is_default, String sign_type,BuildContext context) async {
    // Replace the URL with your server endpoint
    final String url = AppConstants.API_BASE_URL + "/upload_sign_path_mobile";

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth_token'
    };

    request.headers.addAll(headers);

    // You can add additional fields to the request if needed
    request.fields['user_id'] = user_id;
    request.fields['is_default'] = is_default.toString();
    request.fields['sign_type'] = sign_type;

    print(user_id);
    print(sign_type);
    print(is_default);

    // Send the request
    try {
      final response = await request.send();

      print('Response Body: ${await response.stream.bytesToString()}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Signature default successfully');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Default Signature updated successfully')));

        // fetchProfileData(user_id_prefs, auth_token);

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => MySignaturesScreen()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Signature failed')));
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error updating default signature: $error');
    }
  }

}

