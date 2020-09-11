import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class pdf_show extends StatelessWidget {
  File pts;
  pdf_show(this.pts);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pts != null ? PDF.file(pts, height: 700, width: 500,)
                         : Text("Open a Pdf"),
      ),
    );
  }
}