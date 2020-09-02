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
  final List<TableRow> row = <TableRow>[];
  String pdf_name;
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
  pageFormat: PdfPageFormat.standard,
  margin: pw.EdgeInsets.all(5.0),
    build: (pw.Context context) => <pw.Widget>[
        pw.Table(
          children: [
                ...images.map((image){
        return pw.TableRow(
          children: [pw.Image(image),]
          );
      }).toList(),
          ]
        ),
    ],
),
);
     //write to file
     final op = await getExternalStorageDirectory();
     
     String pathtowrite = op.path + '$pdf_name.pdf';
     File op_file = File(pathtowrite);
     await op_file.writeAsBytesSync(pdf.save());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Creating Pdf"
        ),
      ),
      body: Center(
        child: AlertDialog(
          title: Text("Set Pdf file name"),
          content: TextField(
            onChanged: (text){
               pdf_name = text;
            }
          ),
          actions: [
            MaterialButton(
              elevation: 40.0,
                splashColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text('Select Images'),
                onPressed: (){
                  generate_pdf();
                  Navigator.pop(context);
                },
            ),
          ],
        ),
        
      ),
    );
  }
}