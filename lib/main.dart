import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'createpdf.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'pdf_page.dart';

void main(){
  runApp(pdf_maker());
}

class pdf_maker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/pdfpage': (context) => pdf_create(),
      },
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
  File file;
  
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
                Navigator.pushNamed(context, '/pdfpage');
            },
          ),
        ],
      ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

//