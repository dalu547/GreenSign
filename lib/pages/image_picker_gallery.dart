import 'package:flutter/cupertino.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../constants/app_constants.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  bool isUpload = false;
  IconData? iconData = Icons.image;

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
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            String  user_id_prefs = prefs.getString('user_id')!;
            String auth_token = prefs.getString('auth_token')!;
            uploadImage(_image!, auth_token, user_id_prefs,context);
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

Future<void> uploadImage(File imageFile, String auth_token,
    String user_id,BuildContext context) async {
  // Replace the URL with your server endpoint
  final String url = AppConstants.API_BASE_URL + "/update_signature_path";

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
      'image', fileStream, length, filename: 'image.jpg');
  request.files.add(multipartFile);
  request.headers.addAll(headers);

  // You can add additional fields to the request if needed
  request.fields['user_id'] = user_id;

  // Send the request
  try {
    final response = await request.send();

    // Check if the request was successful
    if (response.statusCode == 200) {
      print('Signature from gallery uploaded successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature updated successfully')));
      Navigator.pop(context);
    } else {
      print('Failed to upload Signature from gallery. Status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature update failed')));

    }
  } catch (error) {
    print('Error uploading image: $error');
  }
}
