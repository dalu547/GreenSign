import 'dart:io';

import 'package:GreenSign/poc/login.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'sfpdf_viewer_page_table.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: SelectFile(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class SelectFile extends StatefulWidget {
  SelectFile({Key? key}) : super(key: key);

  @override
  _SelectFileState createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile>
    with SingleTickerProviderStateMixin {
  String _image =
      'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;

  late File _file;
  PlatformFile? _platformFile;
  bool? check1 = false;
  bool? check2 = false;
  bool? check3 = false;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'ppt']);

    if (file != null) {
      setState(() {
        _file = File(file.files.single.path!);
        _platformFile = file.files.first;
      });
    }

    loadingController.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>

          SignInScreen()

          ) );
        },
        ),
        title: Text("Select Document"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            // Image.network(_image, width: 300,),
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
            SizedBox(
              height: 50,
            ),
            Text(
              'Upload Document',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '(Document(s) which needs to be approved.)',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: selectFile,
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.blue.shade400,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.folder_open,
                            color: Colors.blue,
                            size: 40,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Select document(s)',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            _platformFile != null
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected document(s): ',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      Image.asset('assets/images/pdf_icon.png'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _platformFile!.name,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${(_platformFile!.size / 1024).ceil()} KB',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          height: 5,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.blue.shade50,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: loadingController.value,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Select Recipient(s): ',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        CheckboxListTile(
                          //checkbox positioned at right
                          value: check1,
                          controlAffinity: ListTileControlAffinity.leading,
                          //checkbox at left
                          onChanged: (bool? value) {
                            setState(() {
                              check1 = value;

                            });
                          },
                          title: Text("Dalayya Kalla"),
                        ),
                        // CheckboxListTile(
                        //   //checkbox positioned at right
                        //   value: check2,
                        //   controlAffinity: ListTileControlAffinity.leading,
                        //   //checkbox at left
                        //   onChanged: (bool? value) {
                        //     setState(() {
                        //       check2 = value;
                        //     });
                        //   },
                        //   title: Text("Sarma Chada"),
                        // ),
                        // CheckboxListTile(
                        //   //checkbox positioned at right
                        //   value: check3,
                        //   controlAffinity: ListTileControlAffinity.leading,
                        //   //checkbox at left
                        //   onChanged: (bool? value) {
                        //     setState(() {
                        //       check3 = value;
                        //     });
                        //   },
                        //   title: Text("Krishnam Raju M"),
                        // ),
                        SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          height: 45,
                          minWidth: double.infinity,
                          onPressed: () {
                            if (check1!) {
                              // addWaterMark();

                              // addTable();

                              addRect();

                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                              //     PDFViewerPage(file: _file)
                              // ));
                            } else {
                              showAlert(context);
                            }
                          },
                          color: Colors.green,
                          child: Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ))
                : Container(),
            SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showAlert(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Green Sign'),
            content: Text('Please select recipient.'),
            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  addWaterMark() async {
    //Create a new PDF document
    final PdfDocument document =
        PdfDocument(inputBytes: File(_file!.path).readAsBytesSync());

    for(int i = 0;i<document.pages.count ; i++){

      final PdfPage page = document.pages[i];

//Add a page to the document and get page graphics
      PdfGraphics graphics = page.graphics;

//Watermark text
      PdfGraphicsState state = graphics.save();

//Set transparency and rotation
      graphics.setTransparency(0.10);

      graphics.rotateTransform(-40);

//Add text watermark
      page.graphics.drawString(
          'Greenko', PdfStandardFont(PdfFontFamily.helvetica, 64),
          pen: PdfPens.green,
          brush: PdfBrushes.green,
          bounds: Rect.fromLTWH(-150, 450, 0, 0));

//Restore graphics state
      graphics.restore(state);

    }

    String waterMarkFilePath = '/storage/emulated/0/Download/greensign_watermark.pdf';

//Save and dispose the PDF document
    File(waterMarkFilePath)
        .writeAsBytes(await document.save());
    // document.dispose();

    File waterMarkFile = new File(waterMarkFilePath);

    // addTable(waterMarkFilePath);

  }


  addTable() async {

    //Create a new PDF document
    // final PdfDocument document =
    // PdfDocument(inputBytes: File(_file!.path).readAsBytesSync());

    PdfDocument document = PdfDocument(inputBytes: _file.readAsBytesSync());
    final PdfPage pdfPage = document.pages[0];


//Create a PdfGrid class
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 3);

//Add header to the grid
//     grid.headers.add(1);

//Add the rows to the grid
//     PdfGridRow header = grid.headers[0];
//     header.cells[0].value = 'Sign';
//     header.cells[1].value = 'Sign';
//     header.cells[2].value = 'Sign';

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Sign';
    row.cells[1].value = 'Sign';
    row.cells[2].value = 'Sign';

//Add rows to grid
//     PdfGridRow row1 = grid.rows.add();
//     row1.cells[0].value = 'Dalayya K';
//     row1.cells[1].value = 'Raju M';
//     row1.cells[2].value = 'Sarma C';
    //
    // PdfGridRow row2 = grid.rows.add();
    // row2.cells[0].value = 'Lead';
    // row2.cells[1].value = 'Manager';
    // row2.cells[2].value = 'Manager';

//Set the grid style
    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.helvetica, 25));

        grid.draw(page: pdfPage,bounds: const Rect.fromLTWH(0, 0, 0, 0));


//Draw the grid
    // grid.draw(page: page);

    String tableFilePath = '/storage/emulated/0/Download/greensign_watermark_table.pdf';


//Save and dispose the PDF document
    File(tableFilePath).writeAsBytes(await document.save());
    document.dispose();

    File tableFile = new File(tableFilePath);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        SFPDFViewerPageTable(file: tableFile)
    ));

  }

  addRect() async {

    //Create a new PDF document
    final PdfDocument document =
    PdfDocument(inputBytes: File(_file!.path).readAsBytesSync());

    // PdfDocument document = PdfDocument(inputBytes: _file.readAsBytesSync());
    final PdfPage pdfPage = document.pages[1];


//Draw the rectangle on PDF document
    pdfPage.graphics.drawRectangle(
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(10, 10, 100, 50)
    );

    PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
        Rect.fromLTWH(40, 70, 80, 80), 'GREENKO',
        author: 'Syncfusion',
        color: PdfColor(255, 0, 0),
        setAppearance: true,
        modifiedDate: DateTime.now());

    //Adds the annotation to the loaded page
    pdfPage.annotations.add(rectangleAnnotation);


//Draw the grid
    // grid.draw(page: page);

    String tableFilePath = '/storage/emulated/0/Download/greensign_watermark_table.pdf';

//Save and dispose the PDF document
    File(tableFilePath).writeAsBytes(await document.save());
    document.dispose();

    File tableFile = new File(tableFilePath);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        SFPDFViewerPageTable(file: tableFile)
    ));

  }

}
