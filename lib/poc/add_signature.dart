
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:GreenSign/poc/sfpdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:image/image.dart' as IMG;

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';


import 'dart:io';

class AddSignature extends StatefulWidget {
  final String pdfPath;
  AddSignature({required this.pdfPath}
      );

  @override
  _AddSignatureState createState() => _AddSignatureState();
}

class _AddSignatureState extends State<AddSignature> {
  String _filePath = "/storage/emulated/0/Download/greensign_test.pdf";


  bool _isSigned = false;
  Color? _backgroundColor;

  Color? _getBorderColor() => Colors.grey[350];
  double _minWidth = 1.0;
  double _maxWidth = 4.0;

  late Color _strokeColor = const Color.fromRGBO(0, 0, 0, 1);
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  late Uint8List _signatureData;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   // do something
    //   print("Build Completed");
    // });

    // viewPdfFile(_filePath);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>

               SFPDFViewerPage(file: new File(widget.pdfPath))
            
            ) );
          },
        ),
        title: Text("Add Signature"),
      ),
      body: Container(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                // child: Center(
                child: Container(
                    width: 200,
                    height: 100,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/greenko_logo.png')),
                // ),
              ),
              SizedBox(height: 20,),
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {

                  addImageSignatureTOPDF();

                },
                color: Colors.green,
                child: Text('Add image Signature', style: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 40,),
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {

                  addFontSignatureToPdf();

                },
                color: Colors.green,
                child: Text('Add text Signature', style: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 40,),
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  showSignaturePopup();
                },
                color: Colors.green,
                child: Text('Add from Signature Pad', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void addImageSignatureTOPDF() async{

    //Create a new PDF document.
    // final PdfDocument document = PdfDocument();

    //Load the selected PDF document.
    final PdfDocument document =
    PdfDocument(inputBytes: File(widget.pdfPath).readAsBytesSync());

    //Read signature image data.
    final Uint8List imageData = File('/storage/emulated/0/Download/signature.jpg').readAsBytesSync();


    final Uint8List? imageSized = resizeImage(imageData);

//Load the image using PdfBitmap.
    final PdfBitmap image = PdfBitmap(imageSized as List<int>);
//Draw the image to the PDF page.
//     document.pages
//         .add()
//         .graphics
//         .drawImage(image, const Rect.fromLTWH(0, 0, 0, 0));



    //draw signature image on PDF
    final PdfPage page = document.pages[document.pages.count - 1];
    page.graphics.drawImage(image, const Rect.fromLTWH(50, 580, 0, 0));


    //Add Name
    page.graphics.drawString(
        '(Dalayya Kalla)', PdfStandardFont(PdfFontFamily.helvetica, 27),
        brush: PdfBrushes.black,
        bounds: const Rect.fromLTWH(40, 680, 0, 0));

// Save the document which we added signature on that.
    File('/storage/emulated/0/Download/greensign_image_signature.pdf').writeAsBytes(await document.save());
// Dispose the document.
    document.dispose();

    //Open the docuemnt which we added signature on that.
    viewPdfFile('/storage/emulated/0/Download/greensign_image_signature.pdf');

  }

  Uint8List? resizeImage(Uint8List data) {
    Uint8List? resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!, width: 200, height: 100);
    resizedData = IMG.encodeJpg(resized) as Uint8List?;
    return resizedData;
  }

  void viewPdfFile(String path){

    OpenFile.open(path);

  }

  void addFontSignatureToPdf() async{

    final PdfDocument document =
    PdfDocument(inputBytes: File(widget.pdfPath).readAsBytesSync());
//Get the existing PDF page.
    final PdfPage page = document.pages[document.pages.count - 1];

    PdfFont font = await getFont();

    // File font = await getFileFromAssets('fonts/Arial.ttf');


//Draw text in the PDF page.Signature
    page.graphics.drawString(
        'K.Dalayya.', font,
        brush: PdfBrushes.black,
        pen: PdfPen(PdfColor(0, 0, 0), width: 0.5),
        bounds: const Rect.fromLTWH(50, 580, 0, 0));

    //Name
    page.graphics.drawString(
        '(Dalayya Kalla)', PdfStandardFont(PdfFontFamily.helvetica, 24),
        brush: PdfBrushes.black,
        bounds: const Rect.fromLTWH(50, 650, 0, 0));

//Save the document.
    File('/storage/emulated/0/Download/greensign_text_signature.pdf').writeAsBytes(await document.save());
//Dispose the document.
    document.dispose();

    viewPdfFile('/storage/emulated/0/Download/greensign_text_signature.pdf');

  }






  void showSignaturePopup() {
    _isSigned = false;

      _backgroundColor = Colors.white;


    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            final Color? backgroundColor = _backgroundColor;
            final Color textColor = Colors.black87;

            return AlertDialog(
              insetPadding: const EdgeInsets.all(12.0),
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
                        color: false
                            ? Colors.grey[400]
                            : const Color.fromRGBO(0, 0, 0, 0.54),
                        size: 24.0),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 306
                      ? MediaQuery.of(context).size.width
                      : 306,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width < 306
                            ? MediaQuery.of(context).size.width
                            : 306,
                        height: 172,
                        decoration: BoxDecoration(
                          border: Border.all(color: _getBorderColor()!),
                        ),
                        child: SfSignaturePad(
                            minimumStrokeWidth: _minWidth,
                            maximumStrokeWidth: _maxWidth,
                            strokeColor: _strokeColor,
                            backgroundColor: _backgroundColor,
                            onDrawStart: _handleOnDrawStart,
                            key: _signaturePadKey),
                      ),
                      const SizedBox(height: 24),
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
                  // style: ButtonStyle(
                  //   foregroundColor: MaterialStateProperty.all<Color>(
                  //       model.currentPaletteColor),
                  // ),
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
                  // style: ButtonStyle(
                  //   foregroundColor: MaterialStateProperty.all<Color>(
                  //       model.currentPaletteColor),
                  // ),
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

      final ui.Image imageData =
      await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final ByteData? bytes =
      await imageData.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        data = bytes.buffer.asUint8List();
      }


    setState(
          () {
        _signatureData = data;
      },
    );

      addDrawSignatureTOPDF();


  }


  bool _handleOnDrawStart() {
    _isSigned = true;
    return false;
  }

  void addDrawSignatureTOPDF() async{

    //Create a new PDF document.
    // final PdfDocument document = PdfDocument();

    //Load the existing PDF document.
    final PdfDocument document =
    PdfDocument(inputBytes: File(widget.pdfPath).readAsBytesSync());

//Read image data.
//     final Uint8List imageData = File('/storage/emulated/0/Download/signature.jpg').readAsBytesSync();


    final Uint8List? imageSized = resizeImage(_signatureData);

//Load the image using PdfBitmap.
    final PdfBitmap image = PdfBitmap(imageSized as List<int>);
//Draw the image to the PDF page.
//     document.pages
//         .add()
//         .graphics
//         .drawImage(image, const Rect.fromLTWH(0, 0, 0, 0));



    final PdfPage page = document.pages[document.pages.count - 1];
    page.graphics.drawImage(image, const Rect.fromLTWH(50, 580, 0, 0));

    page.graphics.drawString(
        '(Dalayya Kalla)', PdfStandardFont(PdfFontFamily.helvetica, 27),
        brush: PdfBrushes.black,
        bounds: const Rect.fromLTWH(40, 650, 0, 0));

// Save the document.
    File('/storage/emulated/0/Download/greensign_draw_signature.pdf').writeAsBytes(await document.save());
// Dispose the document.
    document.dispose();

    viewPdfFile('/storage/emulated/0/Download/greensign_draw_signature.pdf');

  }


  Future<PdfFont> getFont() async {
    //Get the external storage directory
    // Directory directory = await getApplicationSupportDirectory();
    //Create an empty file to write the font data
    // File file = File('${directory.path}/${style.fontFamily}.ttf');
    // File file = File('assets/fonts/Sacramento-Regular.ttf');

    ByteData bytes = await rootBundle.load('assets/fonts/Sacramento-Regular.ttf'); //load sound from assets
    Uint8List  soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    List<int>? fontBytes;
    //Check if entity with the path exists
    // if (file.existsSync()) {
    //   fontBytes = await file.readAsBytes();
    // }
    if (soundbytes != null && soundbytes.isNotEmpty) {
      //Return the google font
      return PdfTrueTypeFont(soundbytes, 40);
    } else {
      //Return the default font
      return PdfStandardFont(PdfFontFamily.helvetica, 32);
    }
  }

  Future<File> getFileFromAssets(String filename) async {
    assert(filename != null);

    String directory = (await getApplicationDocumentsDirectory()).path;
    final asset= '$directory/$filename';

    final File file = File(asset);
    return file;
  }


// Function to request file access permission and read the file
  Future<void> _requestFilePermissionAndReadFile() async {
    // Check if the app has permission to access files
    if (await _requestFilePermission()) {
      // Permission granted, read the file
      _readFileContents();
    } else {
      // Permission denied, show an error dialog or handle the case as per your app's requirements
      _showPermissionErrorDialog();
    }
  }

// Function to request file access permission
  Future<bool> _requestFilePermission() async {
    if (await Permission.storage
        .request()
        .isGranted) {
      return true;
    } else {
      return false;
    }
  }

// Function to read the file contents
  void _readFileContents() {
    try {
      File file = File(widget.pdfPath);
      if (file.existsSync()) {
        String content = file.readAsStringSync();
        print("File contents: $content");
      } else {
        print("File does not exist.");
      }
    } catch (e) {
      print("Error reading file: $e");
    }
  }

// Function to show an error dialog for permission denial
  void _showPermissionErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Permission Denied"),
          content: Text(
              "Please grant file access permission to read the file."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
