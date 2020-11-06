
import 'dart:convert';

import 'package:animated_background/fitness_app/fintness_app_theme.dart';
import 'package:animated_background/main.dart';
import 'package:animated_background/src/api/api.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_spinkit/flutter_spinkit.dart';
class AttendanceView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final dateNow;
  AttendanceView(
      {Key key, this.dateNow, this.animationController, this.animation})
      : super(key: key);
  Future<String> getSign(String stat,String date) async{

    var res = await CallApi().getData('getActive/$stat/$date');
    String body;
    try{
      body=json.decode(res.body).toString();
    }catch (e){
      print("Error:");
      print(e);
    }
    return body;
  }

  Future<String> getStats() async{
    var res = await CallApi().getData('getStudentCount');
    String body;
    try{
      body=json.decode(res.body).toString();
    }catch (e){

      print(e);
    }
    return body;
  }
  Future<String> getPresents(String date) async{
    var res = await CallApi().getData('getPresents/$date');
    String body="0";
    try{
      body=json.decode(res.body).toString();
    }catch (e){
      print("Error:");
      print(e);
    }
    // print(body);
    return body;
  }
  String _numStudents, _numPresents,_present='0',_late='0',_absent='0';

  double _widthPres=0,_widthLate=0,_widthAbs=0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getStats(),getSign("Present",dateNow),getSign("Late",dateNow),getSign("Absent",dateNow)]),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _numStudents = snapshot.data[0];
              _late = snapshot.data[2];
              _present = snapshot.data[1];
              _absent = snapshot.data[3];
              _numPresents = (int.parse(_late) + int.parse(_present)).toString();
              print(snapshot.data[1]);
              double percentage=0,percent=0;
              if(_numPresents != null){
                percent = (int.parse(_numPresents) / int.parse(_numStudents)) * 100;
              }
              else
              {
                _numPresents="0";
                // _numStudents="0";
                percent = 0;
              }

              // getStats().then((value){
              //   _numStudents = value;
              //   getPresents(dateNow).then((value){
              //     _numPresents = value;
              //   });
              // });
              // getSign("Present",dateNow).then((value){
              //   _present= value;
              //   print("Present: $value");
              //   getSign("Late",dateNow).then((value){
              //     _late= value;
              //     getSign("Absent",dateNow).then((value){
              //       _absent= value;
              //     });
              //   });
              // });
              percentage = double.parse((percent).toStringAsFixed(2));
              String angle = ((percent/100) * 360).toStringAsFixed(2);
              int Total= int.parse(_present) + int.parse(_late) + int.parse(_absent);
              _widthPres = (int.parse(_present) / Total) * 70;
              _widthLate =  (int.parse(_late) / Total) * 70;
              _widthAbs =  (int.parse(_absent) / Total) * 70;
              
              return AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                    opacity: animation,
                    child: new Transform(
                      transform: new Matrix4.translationValues(
                          0.0, 30 * (1.0 - animation.value), 0.0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 16, bottom: 18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FitnessAppTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(68.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: FitnessAppTheme.grey.withOpacity(0.2),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 16, right: 16),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, top: 4),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 48,
                                                  width: 2,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#87A0E5')
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.0)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 4,
                                                            bottom: 2),
                                                        child: Text(
                                                          'Students Sign in',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            FitnessAppTheme
                                                                .fontName,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 16,
                                                            letterSpacing: -0.1,
                                                            color:
                                                            FitnessAppTheme
                                                                .grey
                                                                .withOpacity(
                                                                0.5),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .end,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 28,
                                                            height: 28,
                                                            child: Image.asset(
                                                                "assets/fitness_app/eaten.png"),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4,
                                                                bottom: 3),
                                                            child: Text(
                                                              '${(_numPresents!=null ? int.parse(_numPresents) : 0 * animation.value).toInt()}',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                FitnessAppTheme
                                                                    .fontName,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                                fontSize: 16,
                                                                color: FitnessAppTheme
                                                                    .darkerText,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4,
                                                                bottom: 3),
                                                            child: Text(
                                                              'Students',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                FitnessAppTheme
                                                                    .fontName,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                                fontSize: 12,
                                                                letterSpacing:
                                                                -0.2,
                                                                color: FitnessAppTheme
                                                                    .grey
                                                                    .withOpacity(
                                                                    0.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 48,
                                                  width: 2,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#F56E98')
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.0)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 4,
                                                            bottom: 2),
                                                        child: Text(
                                                          'All Students',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            FitnessAppTheme
                                                                .fontName,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 16,
                                                            letterSpacing: -0.1,
                                                            color:
                                                            FitnessAppTheme
                                                                .grey
                                                                .withOpacity(
                                                                0.5),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .end,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 28,
                                                            height: 28,
                                                            child: Image.asset(
                                                                "assets/fitness_app/burned.png"),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4,
                                                                bottom: 3),
                                                            child: Text(
                                                              '${(int.parse(_numStudents!=null? _numStudents : "0") * animation.value).toInt()}',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                FitnessAppTheme
                                                                    .fontName,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                                fontSize: 16,
                                                                color: FitnessAppTheme
                                                                    .darkerText,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8,
                                                                bottom: 3),
                                                            child: Text(
                                                              'Students',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                FitnessAppTheme
                                                                    .fontName,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                                fontSize: 12,
                                                                letterSpacing:
                                                                -0.2,
                                                                color: FitnessAppTheme
                                                                    .grey
                                                                    .withOpacity(
                                                                    0.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Center(
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: FitnessAppTheme.white,
                                                  borderRadius:
                                                  BorderRadius.all(
                                                    Radius.circular(100.0),
                                                  ),
                                                  border: new Border.all(
                                                      width: 4,
                                                      color: FitnessAppTheme
                                                          .nearlyDarkBlue
                                                          .withOpacity(0.2)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '${(percentage * animation.value).toDouble().isNaN?0:(percentage * animation.value).toDouble()}' + "%",
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        FitnessAppTheme
                                                            .fontName,
                                                        fontWeight:
                                                        FontWeight.normal,
                                                        fontSize: 24,
                                                        letterSpacing: 0.0,
                                                        color: FitnessAppTheme
                                                            .nearlyDarkBlue,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   '',
                                                    //   textAlign:
                                                    //   TextAlign.center,
                                                    //   style: TextStyle(
                                                    //     fontFamily:
                                                    //     FitnessAppTheme
                                                    //         .fontName,
                                                    //     fontWeight:
                                                    //     FontWeight.bold,
                                                    //     fontSize: 20,
                                                    //     letterSpacing: 0.0,
                                                    //     color: FitnessAppTheme
                                                    //         .grey
                                                    //         .withOpacity(0.5),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(4.0),
                                              child: CustomPaint(
                                                painter: CurvePainter(
                                                    colors: [
                                                      FitnessAppTheme
                                                          .nearlyDarkBlue,
                                                      HexColor("#8A98E8"),
                                                      HexColor("#8A98E8")
                                                    ],

                                                    angle: double.parse(angle) +
                                                        (360 - double.parse(angle)) *
                                                            (1.0 -
                                                                animation
                                                                    .value)),
                                                child: SizedBox(
                                                  width: 108,
                                                  height: 108,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 8, bottom: 8),
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: FitnessAppTheme.background,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 8, bottom: 16),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Present',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                              FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.2,
                                              color: FitnessAppTheme.darkText,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 4,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: HexColor('#87A0E5')
                                                    .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: ((_widthPres.isNaN?0:_widthPres) *
                                                        animation.value),
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            HexColor('#87A0E5'),
                                                            HexColor('#87A0E5')
                                                                .withOpacity(
                                                                0.5),
                                                          ]),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              4.0)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 6),
                                            child: Text(
                                              _present,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: FitnessAppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Late',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                  FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.2,
                                                  color:
                                                  FitnessAppTheme.darkText,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Container(
                                                  height: 4,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#F56E98')
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.0)),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: ((_widthLate.isNaN?0:_widthLate) *
                                                            animationController
                                                                .value),
                                                        height: 4,
                                                        decoration:
                                                        BoxDecoration(
                                                          gradient:
                                                          LinearGradient(
                                                              colors: [
                                                                HexColor(
                                                                    '#F56E98')
                                                                    .withOpacity(
                                                                    0.1),
                                                                HexColor(
                                                                    '#F56E98'),
                                                              ]),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius
                                                                  .circular(
                                                                  4.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6),
                                                child: Text(
                                                  _late,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: FitnessAppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Absent',
                                                style: TextStyle(
                                                  fontFamily:
                                                  FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.2,
                                                  color:
                                                  FitnessAppTheme.darkText,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0, top: 4),
                                                child: Container(
                                                  height: 4,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#F1B440')
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.0)),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: ((_widthAbs.isNaN?0:_widthAbs) *
                                                            animationController
                                                                .value),
                                                        height: 4,
                                                        decoration:
                                                        BoxDecoration(
                                                          gradient:
                                                          LinearGradient(
                                                              colors: [
                                                                HexColor(
                                                                    '#F1B440')
                                                                    .withOpacity(
                                                                    0.1),
                                                                HexColor(
                                                                    '#F1B440'),
                                                              ]),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius
                                                                  .circular(
                                                                  4.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6),
                                                child: Text(
                                                  '$_absent',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: FitnessAppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            default:
              return SpinKitWave(
                color: Colors.blueAccent,
                size: 50.0,
              );
          }
        });
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
