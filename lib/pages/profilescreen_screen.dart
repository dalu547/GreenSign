import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';


import 'package:GreenSign/constants/app_constants.dart';
import 'package:GreenSign/model/profile.dart';
import 'package:GreenSign/pages/camera_screen.dart';
import 'package:GreenSign/pages/image_picker_gallery.dart';
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
                    CachedNetworkImage(
                      imageUrl: profile!.data!.user?.profile_image ?? "",
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(height: 8.v),
                    Text(
                      "Edit",
                      style: CustomTextStyles.bodyMediumPrimary,
                    ),
                    SizedBox(height: 25.v),
                    _buildUploadOptions(context),
                    SizedBox(height: 16.v),
                    _buildCardWithBorder(
                      context,
                      mobileNo: profile!.data?.user?.first_name ?? "",
                      value: profile!.data?.user?.last_name ?? "",
                      company: profile!.data?.user?.email_address ?? "",
                      deskNumber: "**********",
                      address: "**********",
                    ),
                    SizedBox(height: 24.v),
                    _buildCardWithBorder(
                      context,
                      mobileNo: profile!.data?.user?.mobile ?? "",
                      value: profile!.data?.user?.role_name ?? "",
                      company: profile!.data!.user?.company ?? "",
                      deskNumber: profile!.data!.user?.desk_number ?? "",
                      address: profile!.data!.user?.address ?? "",
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
            imageUrl: profile!.data?.user?.digital_signature ?? "",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(height: 5.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  print("Camera");
                  uploadSignatureFromCamera();
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
                            "Choose",
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
                  drawSignature();

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

                  uploadSignatureFromGallery();

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

  void uploadSignatureFromGallery() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ImagePickerScreen()));
  }

  void drawSignature() {

     _showPopup();

    // Navigator.push(context, MaterialPageRoute(builder: (_) => SignaturePage()));


  }

  Future<void> uploadSignatureFromCamera() async {

    // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    Navigator.push(context, MaterialPageRoute(builder: (_) => TakePictureScreen(camera: firstCamera)));

  }

  Color? _getTextColor() => Colors.grey[700];
  Color? _getBorderColor() => Colors.grey[350];

  //Signature Pad.
  void _showPopup() {
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
                    _handleSaveButtonPressed();
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

  Future<void> _handleSaveButtonPressed() async {
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

    uploadImage(file, auth_token, user_id_prefs);

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
  Future<void> uploadImage(File imageFile,String auth_token,String user_id) async {
    // Replace the URL with your server endpoint
    final String url = AppConstants.API_BASE_URL+"/update_signature_path";

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    Map<String,String> headers= {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $auth_token'
    };

    // Add the image file to the request
    var fileStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('image', fileStream, length, filename: 'image.jpg');
    request.files.add(multipartFile);
    request.headers.addAll(headers);

    // You can add additional fields to the request if needed
    request.fields['user_id'] = user_id;

    // Send the request
    try {
      final response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Signature draw successfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature updated successfully')));
      } else {
        print('Failed to signature draw. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature failed')));
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

}
