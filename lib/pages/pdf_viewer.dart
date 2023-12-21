import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatelessWidget {
  final String pdfPath; // Provide the path or URL to the PDF file

  PDFScreen(this.pdfPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onRender: (pages) {
          // Callback when PDF is rendered
          print("PDF is rendered with $pages pages.");
        },
        onError: (error) {
          // Callback when an error occurs
          print("Error: $error");
        },
        onPageError: (page, error) {
          // Callback when an error occurs on a specific page
          print("Error on page $page: $error");
        },
        // onPageChanged: (int page, int total) {
        //   // Callback when the page changes
        //   print("Page changed: $page/$total");
        // },
      ),
    );
  }
}
