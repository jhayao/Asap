import 'dart:developer';
import 'dart:io';

import 'package:animated_background/fitness_app/payment/design_course_app_theme.dart';
import 'package:animated_background/fitness_app/payment/paymentpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode result;
  QRViewController controller;
  var qrViewOpened = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var granted= false;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Align(alignment: Alignment.bottomCenter,
          child: result != null ?
          Text('Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.nearlyBlue,
            ),
          ) :
              Text("Scanning")
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              width: AppBar().preferredSize.height,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                      AppBar().preferredSize.height),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;

    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );



  }

  void _onQRViewCreated(QRViewController controller) {

    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async{
      result = scanData;
      await controller.pauseCamera();
      List qrCode = result.code.toString().split(':');
      if(qrCode.contains('ssc.codes'))
          {
            if (!qrViewOpened) {
              qrViewOpened = true;
              var secondScreen = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CourseInfoScreen(studentNumber: qrCode[1] ,user_type: 'Admin',)));
              if (secondScreen) {
                qrViewOpened = false;
                await controller.resumeCamera();
              }
            }
          }
    });
  }



  void moveTo(studentID) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CourseInfoScreen(studentNumber: studentID ,user_type: 'Admin',),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
