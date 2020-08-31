import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class pdf_create extends StatefulWidget {
  @override
  _pdf_createState createState() => _pdf_createState();
}

class _pdf_createState extends State<pdf_create> {
  String pdf_name;
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
  final pdf = pw.Document();
  List<File> temp;
  void generate_pdf() async {
    try {
      temp = await FilePicker.getMultiFile(
        type: FileType.image,
        allowCompression: true,
      );
    } 
    on Exception catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error....'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {},
                )
              ],
            );
          });
    }
  
final images = await temp.map(
  (cnv) => PdfImage.file(
    pdf.document,
    bytes: cnv.readAsBytesSync(),
    orientation: PdfImageOrientation.topRight,
  ),
);

pdf.addPage(pw.MultiPage(
    build: (pw.Context context) => <pw.Widget>[
      ...images.map((image){
        return pw.Center(
          child: pw.Image(image),
          // heightFactor: 10.0,
          // widthFactor: 60.0,
          );
      }).toList(),

    ],
),
);
     //write to file
     final op = await getExternalStorageDirectory();
     
     String pathtowrite = op.path + 'test.pdf';
     File op_file = File(pathtowrite);
     print('$pdf_name');
     print(pathtowrite);
     await op_file.writeAsBytesSync(pdf.save());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Column(
              children: [
                Container(
              padding: EdgeInsets.only(left: 5.0),
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: TextField(
                              ),
                            ),
                          ),
              MaterialButton(
                child: Text('Make pdf from images'),
                onPressed: (){
                  generate_pdf();
                  Navigator.pop(context);
                },
              ),

              ],
            ),
          ],
        ),
        
      ),
    );
  }
}