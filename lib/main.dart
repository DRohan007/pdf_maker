import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

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
  File file;
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
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            File picked_file = await FilePicker.getFile(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            setState(() {
              file = picked_file;
            });
          },
          child: Icon(Icons.picture_as_pdf),
          tooltip: "Open Pdf",
          splashColor: Colors.deepPurpleAccent,
          ),
    );
  }
}
//