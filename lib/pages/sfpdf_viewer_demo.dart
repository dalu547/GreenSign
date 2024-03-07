import 'dart:typed_data';
import 'dart:ui';

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:http/http.dart' as http;

import '../widgets/mobile_image_converter.dart';

import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class SFPDFDemoScreen extends StatefulWidget {
  SFPDFDemoScreen();

  @override
  _SFPDFDemoScreenState createState() => _SFPDFDemoScreenState();
}

class _SFPDFDemoScreenState extends State<SFPDFDemoScreen> {
  Uint8List? _documentBytes;


  bool _isSigned = false;
  late bool _isWebOrDesktop;
  double _minWidth = 1.0;
  double _maxWidth = 4.0;
  late Color _strokeColor = const Color.fromRGBO(0, 0, 0, 1);
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  late Uint8List _signatureData;
  Color currentPaletteColor = const Color.fromRGBO(0, 116, 227, 1);

  Color? _getTextColor() => Colors.grey[700];
  Color? _getBorderColor() => Colors.grey[350];

  @override
  void initState() {

    _isWebOrDesktop = defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        kIsWeb;

    getPdfBytes();

    super.initState();
  }

  ///Get the PDF document as bytes
  void getPdfBytes() async {
    _documentBytes = await http.readBytes(Uri.parse(
        'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("PDF Access"),
      ),
      body: Expanded(
        child: _documentBytes != null
            ? SfPdfViewer.memory(
                _documentBytes!,
                onTap: (PdfGestureDetails details) {
                  print('${details.pageNumber}');
                  print('${details.pagePosition}');
                  print('${details.position}');

                  _showPopup(details.pageNumber,details.pagePosition,details.position);

                },
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }


  //Signature Pad.
  void _showPopup(int pageNumber,Offset pagePosition,Offset position) {
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
                    _handleSaveButtonPressed(pageNumber,pagePosition,position);
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

  _handleSaveButtonPressed(int pageNumber,Offset pagePosition,Offset position) async {
    // late Uint8List data;
    //
    // if (kIsWeb) {
    //   final RenderSignaturePad renderSignaturePad =
    //   _signaturePadKey.currentState!.context.findRenderObject()!
    //   as RenderSignaturePad;
    //   data =
    //   await ImageConverter.toImage(renderSignaturePad: renderSignaturePad);
    // } else {

    //   final ui.Image imageData =
    //   await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);

    final data =
    await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);

    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);




    // final ByteData? bytes =
    //   await imageData.toByteData(format: ui.ImageByteFormat.png);

      // if (bytes != null) {
      //   data = bytes.buffer.asUint8List();
      // }
    // }

    // setState(
    //       () {
    //     _signatureData = data;
    //   },
    // );

    // addSignatureToPDF();

    PdfDocument document = PdfDocument(inputBytes: _documentBytes);
    PdfPage page = document.pages[pageNumber-1];

    double sign_width = 250;
    double sign_height = 200;

    page.graphics?.drawImage(PdfBitmap(bytes!.buffer.asUint8List()),
            Rect.fromLTWH(pagePosition.dx ,pagePosition.dy - sign_height/2 , sign_width, sign_height));

    // page.graphics?.drawImage(PdfBitmap(bytes!.buffer.asUint8List()),
    //     Rect.fromLTWH(position.dx,position.dy,250,200));

    _documentBytes = Uint8List.fromList(await document.save());
    document.dispose();
    setState(() {});

  }

  bool _handleOnDrawStart() {
    _isSigned = true;
    return false;
  }

  void addSignatureToPDF() {

  }

}
