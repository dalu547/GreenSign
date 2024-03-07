import 'package:flutter/cupertino.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../constants/app_constants.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'initial_signatures_screen.dart';
import 'long_signatures_screen.dart';

class ImagePickerScreen extends StatefulWidget {

  bool isSignatureSelected;
  String sign_type;
  String from;

  ImagePickerScreen(this.isSignatureSelected,this.sign_type,this.from);


  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState(isSignatureSelected,sign_type,from);
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  bool isUpload = false;
  IconData? iconData = Icons.image;

  bool isSignatureSelected;
  String sign_type;
  String from;

  String user_id_prefs = "";
  String auth_token = "";

  _ImagePickerScreenState(this.isSignatureSelected, this.sign_type,this.from);

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id_prefs = prefs.getString('user_id')!;
    auth_token = prefs.getString('auth_token')!;

    print('user id from getData ${user_id_prefs}');

    setState(() {
      user_id_prefs = prefs.getString('user_id')!;
      print('user id from getPrefsData setState ${user_id_prefs}');
    });
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        isUpload = true;
        iconData = Icons.upload_file;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Signature'),
      ),
      body: Center(
        child: _image == null
            ? Text('No signature image selected.\n Please select from gallery')
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          if(isUpload){
            uploadImage(_image!, auth_token, user_id_prefs,sign_type,isSignatureSelected,context,from);
          }else{
            _pickImage();
          }

        },
        tooltip: 'Pick Signature',
        child: Icon(iconData),
      ),
    );
  }

}

Future<void> uploadImage(File imageFile, String auth_token,String user_id,String sign_type,
    bool is_default,BuildContext context, String from) async {
  // Replace the URL with your server endpoint
  final String url = AppConstants.API_BASE_URL + "/upload_sign_path_mobile";

  // Create a multipart request
  var request = http.MultipartRequest('POST', Uri.parse(url));

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $auth_token'
  };

  // Add the image file to the request
  var fileStream = http.ByteStream(imageFile.openRead());
  var length = await imageFile.length();
  var multipartFile = http.MultipartFile(
      'file', fileStream, length, filename: 'image.jpg');
  request.files.add(multipartFile);
  request.headers.addAll(headers);

  // You can add additional fields to the request if needed
  request.fields['user_id'] = user_id;
  request.fields['is_default'] = is_default.toString();
  request.fields['sign_type'] = sign_type;

  // Send the request
  try {
    final response = await request.send();

    // Check if the request was successful
    if (response.statusCode == 200) {
      print('Signature from gallery uploaded successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature updated successfully')));

      Navigator.pop(context);
      if(from == "long_signature"){
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LongSignaturesScreen()));
      }else if(from == "initial"){
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => InitialSignaturesScreen()));
      }

    } else {
      print('Failed to upload Signature from gallery. Status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature update failed')));

    }
  } catch (error) {
    print('Error uploading image: $error');
  }
}
