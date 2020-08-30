import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'pdf_page.dart';

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
  List<File> temp;
  File file;
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
     
     String pathtowrite = op.path + '/test5.pdf';
     File op_file = File(pathtowrite);
     print(pathtowrite);
     await op_file.writeAsBytesSync(pdf.save());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf Maker"),
      ),
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
             Center(
                child: Text("Pdf Maker"),
                   ),
        ],
      ),
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => pdf_show(file),
                ),
                );
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