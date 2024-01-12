import 'dart:async';
import 'dart:io';

import 'package:GreenSign/pages/profilescreen_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../constants/app_constants.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';


// Future<void> main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();
//
//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;
//
//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Signature')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image.path,
                    ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}



// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;


  const DisplayPictureScreen({super.key, required this.imagePath});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Signature')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {

            final SharedPreferences prefs = await SharedPreferences.getInstance();
           String  user_id_prefs = prefs.getString('user_id')!;
           String auth_token = prefs.getString('auth_token')!;

                 print("upload");
            // Create a File object using the image path
                File imageFile = File(imagePath);
                // Check if the file exists
                if (imageFile.existsSync()) {
                  print('File exists');
                  uploadImage(imageFile, auth_token, user_id_prefs,context);
                  // You can use the imageFile as needed
                } else {
                  print('File does not exist');
                }
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.upload_file),
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
      print('Signature from capture successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature updated successfully')));
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilescreenScreen("")));

    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signature update fail')));

    }
  } catch (error) {
    print('Error uploading image: $error');
  }
}
