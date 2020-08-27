import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main(){
  runApp(pdf_maker());
}

class pdf_maker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home_Page(),      
    );
  }
}
class Home_Page extends StatefulWidget {
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final pdf = pw.Document();
  File file;
  void generate_pdf() async {
  File temp = await FilePicker.getFile(
    type: FileType.custom,
    allowedExtensions: ['jpeg'],
              //  allowedExtensions: ['pdf'],
              );
  
  final image = PdfImage.file(
  pdf.document,
  bytes: temp.readAsBytesSync(),
);

pdf.addPage(pw.Page(
    build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(image),
      );// Center
    }));
    //write to file
    final op = await getExternalStorageDirectory();
    String pathtowrite = op.path + '/test2.pdf';
    File op_file = File(pathtowrite);
    await op_file.writeAsBytesSync(pdf.save());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf Maker"),
      ),
      body: Center(
        child: file != null ? PDF.file(file, height: 700, width: 500,)
          : Text("Open a Pdf"), 
      ),
      // IconButton(
      //   onPressed: (){},
      //   icon: Icons.create_new_folder,
      // ),
      floatingActionButton: SpeedDial(
        tooltip: "Tap",
        child: Icon(Icons.menu),
        children: [
          SpeedDialChild(
            child: Icon(Icons.picture_as_pdf),
            label: 'Open Pdf',
            onTap: () async {
              File picked_file = await FilePicker.getFile(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );
              setState(() {
                file = picked_file;
              });
            },
          ),
          SpeedDialChild(
            label: "Create Pdf",
            child: Icon(Icons.create_new_folder),
            onTap: () {
              generate_pdf();
            },
          ),
        ],
      ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
//