import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:toast/toast.dart';
import 'package:animated_background/fitness_app/payment/student_model.dart';
import 'package:animated_background/fitness_app/payment/user_model.dart';
import 'package:animated_background/qr/generate.dart';
import 'package:animated_background/src/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'design_course_app_theme.dart';

class CourseInfoScreen extends StatefulWidget {
  final String studentNumber;
  final String user_type;

  const CourseInfoScreen({Key key, this.studentNumber, this.user_type})
      : super(key: key);

  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  StudentModel userDetails;
  Future eventFuture;
  String name;
  String avatar, late, present, absent, noSign, fines, studentnumber;

  _CourseInfoScreenState();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    eventFuture = getData();
    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return new WillPopScope(
      onWillPop: () async => false,
      child: Container(
          color: DesignCourseAppTheme.nearlyWhite,
          child: FutureBuilder(
              future: eventFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      children: <Widget>[

                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1.2,
                              child: Image.network(
                                  avatar != null
                                      ? avatar
                                      : 'https://ssc.codes/storage/users/default.png',
                                  fit: BoxFit.fill),
                            ),
                          ],
                        ),
                        Positioned(
                          top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: DesignCourseAppTheme.nearlyWhite,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(32.0),
                                  topRight: Radius.circular(32.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: DesignCourseAppTheme.grey
                                        .withOpacity(0.2),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: SingleChildScrollView(
                                child: Container(
                                  constraints: BoxConstraints(
                                      minHeight: infoHeight,
                                      maxHeight: tempHeight > infoHeight
                                          ? tempHeight
                                          : infoHeight),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 32.0, left: 18, right: 16),
                                        child: Text(
                                          name != null ? name : "Student Name",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                            letterSpacing: 0.27,
                                            color:
                                                DesignCourseAppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            bottom: 8,
                                            top: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              fines != null ? fines : '',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 22,
                                                letterSpacing: 0.27,
                                                color: DesignCourseAppTheme
                                                    .nearlyBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        opacity: opacity1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Wrap(
                                            children: <Widget>[
                                              getTimeBoxUI(
                                                  absent != null ? absent : '',
                                                  'Absents'),
                                              getTimeBoxUI(
                                                  present != null
                                                      ? present
                                                      : '',
                                                  'Presents'),
                                              getTimeBoxUI(
                                                  late != null ? late : '',
                                                  'Lates'),
                                              getTimeBoxUI(
                                                  noSign != null ? noSign : '',
                                                  'No Sign outs'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: opacity2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 8,
                                                bottom: 8),
                                            child: Text(
                                              'For more information about your Fines and Attendance, please visit https://ssc.codes/',
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color:
                                                    DesignCourseAppTheme.grey,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        opacity: opacity3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, bottom: 30, right: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(16.0),
                                                    ),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyBlue
                                                                  .withOpacity(
                                                                      0.5),
                                                          offset: const Offset(
                                                              1.1, 1.1),
                                                          blurRadius: 10.0),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: TextButton.icon(
                                                      onPressed: () {
                                                        widget.user_type ==
                                                                "Admin"
                                                            ? fines!='Paid' ? addPayment() : print('Paid')
                                                            : moveTo();
                                                      },
                                                      icon: widget.user_type ==
                                                              "Admin"
                                                          ? Icon(
                                                              Icons.payment,
                                                              color:
                                                                  Colors.white,
                                                              size: 30.0,
                                                            )
                                                          : Icon(
                                                              Icons.qr_code,
                                                              color:
                                                                  Colors.white,
                                                              size: 30.0,
                                                            ),
                                                      label: Text(
                                                        widget.user_type ==
                                                                "Admin"
                                                            ? fines!='Paid' ?'Received Payment' : 'Paid'
                                                            : 'Generate QR',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18,
                                                          letterSpacing: 0.0,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyWhite,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context)
                                                .padding
                                                .bottom +
                                            50,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                          child: SizedBox(
                            width: AppBar().preferredSize.height,
                            height: AppBar().preferredSize.height,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                BorderRadius.circular(AppBar().preferredSize.height),
                                child:widget.user_type ==
                                    "Admin"
                                    ?  Icon(
                                  Icons.arrow_back_ios,
                                  color: DesignCourseAppTheme.nearlyBlack
                                  ,
                                ) : null,
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SpinKitWave(
                    color: Colors.blueAccent,
                    size: 50.0,
                  );
                }
              })),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => GeneratePage(
          studentID: widget.studentNumber,
        ),
      ),
    );
  }

  Future getData() async {
    var res, body;
    var data = {
      'id': widget.studentNumber,
    };
    var tempName = "";
    var tempAvatar;
    var tempLate;
    var tempAbs;
    var tempPres;
    var tempNo;
    var tempFines;
    try {
      res = await CallApi().postData(data, 'selectedStudent');
      body = json.decode(res.body);

      tempName = body['name'];
      tempAvatar = 'https://ssc.codes/storage/' + body['avatar'];

      tempNo = body['nosign'].toString();
      tempLate = body['late'].toString();
      tempAbs = body['absent'].toString();
      tempPres = body['present'].toString();


      if(body['fines'].toString() == 'null')
        {
          tempFines = 'Paid';
        }
      else
        {
          tempFines = "₱" +  body['fines'].toString();
        }
    } catch (e) {
      tempName = "Null";
      log("error: $e");
    } finally {
      setState(() {
        name = tempName;
        avatar = tempAvatar;
        fines = tempFines;
        late = tempLate;
        absent = tempAbs;
        present = tempPres;
        noSign = tempNo;
        studentnumber = body['studentnumber'].toString();
        print('$noSign');
      });
    }

    return true;
  }

  showAlertDialogs(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Paid Success"),
      content: Text("Payment Succesfully Saved"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        content: Container(
      height: 40,
      child: new Row(
        children: [
          // SpinKitFadingCircle(
          //   color: Colors.blueAccent,
          //   size: 40.0,
          // ),
          // Container(margin: EdgeInsets.only(left: 15),child:Text("Signing in" )),
          GFLoader(
            type: GFLoaderType.circle,
            size: 20.0,
          ),
          Container(
              margin: EdgeInsets.only(left: 15),
              child: Text("Connecting to Database")),
        ],
      ),
    ));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addPayment() async {
    var res, body;

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');

    var user = json.decode(userJson);

    var username = user['id'];
    // print(user);
    String fine = fines.substring(1);
    var data = {
      'fines': fines.substring(1),
      'studentnumber': widget.studentNumber,
      'currentuser': username,
      'paid': fines.substring(1),
    };
    print(data);
    showAlertDialog(context);
    try {
      res = await CallApi().postData(data, 'addPayment');
      body = json.decode(res.body);
      print(body);
      Navigator.of(context, rootNavigator: true).pop('dialog');
      if(body!=null)
        {
          showAlertDialogs(context);
        }
    } catch (e) {
      log('error : $e');
      Toast.show("No Internet Connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pop(context);
    }
    // finally{
    //   setState(() {
    //     _isLoading = false;
    //   });
    //
    // }

    // var body = json.decode(res.body);
    // print(body);
    // try {
    //   var body = json.decode(res.body);
    //   print(body);
    //   if (body['success']) {
    //     SharedPreferences localStorage = await SharedPreferences.getInstance();
    //     localStorage.setString('token', body['token']);
    //     localStorage.setString('user', json.encode(body['user']));
    //
    //     var userJson = localStorage.getString('user');
    //     var user = json.decode(userJson);
    //     print(user['name']);
    //
    //     Navigator.pushReplacement(
    //       context,
    //       // PageRouteBuilder(pageBuilder: (context, anim1, anim2) => FitnessAppHomeScreen()),
    //       // PageRouteBuilder(pageBuilder: (context,anim1,anim2)=>NavigationHomeScreen());
    //         PageRouteBuilder(pageBuilder: (context, anim1, anim2) => NavigationHomeScreen()),
    //     );
    //   }
    //   else {
    //     Alert(
    //       context: context,
    //       type: AlertType.error,
    //       title: "Authentication Error",
    //       desc: "Invalid Username or Password",
    //       buttons: [
    //         DialogButton(
    //           child: Text(
    //             "Try Again",
    //             style: TextStyle(color: Colors.white, fontSize: 20),
    //           ),
    //           onPressed: () => Navigator.pop(context),
    //           color: Color.fromRGBO(0, 179, 134, 1.0),
    //         ),
    //
    //       ],
    //     ).show();
    //   }
    // } on NoSuchMethodError catch (e)
    // {
    //   Alert(
    //     context: context,
    //     type: AlertType.error,
    //     title: "Network Error",
    //     desc: "Check your Internet Connection or Contact System Administrator",
    //     buttons: [
    //       DialogButton(
    //         child: Text(
    //           "Try Again",
    //           style: TextStyle(color: Colors.white, fontSize: 20),
    //         ),
    //         onPressed: () => Navigator.pop(context),
    //         color: Color.fromRGBO(0, 179, 134, 1.0),
    //       ),
    //     ],
    //   ).show();
    // }
    // setState(() {
    //   _isLoading = false;
    // });
    // // print(body);
  }
}
