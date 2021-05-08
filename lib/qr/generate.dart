

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class GeneratePage extends StatefulWidget {
  final String studentID;

  const GeneratePage({Key key, this.studentID}) : super(key: key);
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {


  String qrData = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  void setData()
  {
    setState(() {
      qrData = 'ssc.codes:' + widget.studentID;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Code Generator',textAlign: TextAlign.center,),
        actions: <Widget>[],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImage(
              //plce where the QR Image will be shown
              data: qrData,
              version: 4,
              embeddedImage: AssetImage('assets/images/logo.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(80, 80),
              ),
              // size: 200.0,
            ),
            SizedBox(
              height: 40.0,
            ),

          ],
        ),
      ),
    );
  }

  final qrdataFeed = TextEditingController();
}
