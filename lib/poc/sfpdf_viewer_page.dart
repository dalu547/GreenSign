import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:GreenSign/poc/add_signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:image/image.dart' as IMG;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'select_file.dart';



class SFPDFViewerPage extends StatefulWidget {
  File file;

  SFPDFViewerPage({
    required this.file,
  }) ;

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<SFPDFViewerPage> {
  // late PDFViewController controller;
  final PdfViewerController controller = PdfViewerController();

  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file!.path);
    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>

                SelectFile()

            ) );
          },
        ),

        title: Text(name),
        actions: pages >= 2
            ? [
                Center(child: Text(text)),
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 32),
                  onPressed: () {
                    final page = indexPage == 0 ? pages : indexPage - 1;
                    // controller.setPage(page);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 32),
                  onPressed: () {
                    final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                    // controller.setPage(page);
                    },
                ),
              ]
            : null,
      ),
      body: SfPdfViewer.file(widget.file,
        onTap: (PdfGestureDetails details) {
          // print('${details.pageNumber}');
          print('onTap detected');
          print("${details.position.dx} -- ${details.position.dy}");
        },

        controller: controller,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0), //the one you prefer
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>

                  AddSignature(pdfPath: widget.file!.path)


                  ));
                },
                child: Text("Sign"),
              ),
            ),
            SizedBox(
              //space between button
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Background color
                ),
                onPressed: () {
                    _displayTextInputDialog(context);
                },
                child: Text("Reject"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _textFieldController = TextEditingController();
  String? codeDialog;
  String? valueText;
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Comments:'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              maxLines: 5,
              controller: _textFieldController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add your comment here.."),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Reject'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                    addRejectedStampOnPDF(codeDialog!);
                  });
                },
              ),
            ],
          );
        });
  }


  void addRejectedStampOnPDF(String rejectedCOmments) async{

    //Create a new PDF document.
    // final PdfDocument document = PdfDocument();

    //Load the selected PDF document.
    final PdfDocument document =
    PdfDocument(inputBytes: File(widget.file!.path).readAsBytesSync());

    //Read signature image data.
    // Uint8List? bytesFile;
    // Uri myUri = Uri.parse('assets/images/rejected_rounded_iocn.jpg');
    // File localFile = new File.fromUri(myUri);
    // await localFile.readAsBytes().then((value) {
    //    bytesFile = Uint8List.fromList(value);
    //   print('reading of bytes is completed');
    //
    // }).catchError((onError) {
    //   print('Exception Error while reading audio from path:' +
    //       onError.toString());
    // });


    // final Uint8List imageData = File.fromUri(myUri).readAsBytesSync();


    final Uint8List imageData = File('/storage/emulated/0/Download/rejected_rounded_icon.jpg').readAsBytesSync();


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

    //Aadd comments
    page.graphics.drawString(
        '[Comments: $rejectedCOmments]', PdfStandardFont(PdfFontFamily.helvetica, 27),
        brush: PdfBrushes.black,
        pen: PdfPen(PdfColor(0, 0, 0), width: 0.5),
        bounds: const Rect.fromLTWH(40, 720, 0, 0));

// Save the document which we added signature on that.
    File('/storage/emulated/0/Download/greensign_reject_signature.pdf').writeAsBytes(await document.save());
// Dispose the document.
    document.dispose();

    //Open the docuemnt which we added signature on that.
    viewPdfFile('/storage/emulated/0/Download/greensign_reject_signature.pdf');

  }

  Uint8List? resizeImage(Uint8List data) {
    Uint8List? resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!, width: 150, height: 150);
    resizedData = IMG.encodeJpg(resized) as Uint8List?;
    return resizedData;
  }

  void viewPdfFile(String path){
    OpenFile.open(path);
  }

}
