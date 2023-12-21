import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SFPDFScreen extends StatelessWidget {
  final String pdfPath;
  final String documentName;

  SFPDFScreen(this.pdfPath, this.documentName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(documentName),
        ),
        body: SfPdfViewer.network(pdfPath));
  }
}
