import 'dart:async';
import 'dart:convert';

import 'package:animated_background/fitness_app/asap_app_home_screen.dart';
import 'package:animated_background/homePage/navigation_home_screen.dart';
import 'package:animated_background/src/api/api.dart';
import 'package:animated_background/src/custom_button.dart';
import 'package:animated_background/src/onboarding_page.dart';
import 'package:animated_background/src/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
// import 'package:rich_alert/rich_alert.dart';
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  AnimationController _signUpAnimationController;
  Animation<double> _signUpAnimation;

  AnimationController _signInAnimationController;
  Animation<double> _signInAnimation;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  // Tex
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));

    _signUpAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _signInAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });

    Future.delayed(Duration.zero, () {
      _signUpAnimation =
      Tween(begin: MediaQuery.of(context).size.height, end: 450.0).animate(
          _signUpAnimationController
              .drive(CurveTween(curve: Curves.easeOut)))
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((animationStatus) {
          if (animationStatus == AnimationStatus.completed) {
            _signInAnimationController.forward();
          }
        });

      _signInAnimation = Tween(begin: -32.0, end: 16.0).animate(
          _signInAnimationController.drive(CurveTween(curve: Curves.easeOut)))
        ..addListener(() {
          setState(() {});
        });
    });

    _animationController.forward();

    _signUpAnimationController.forward();
  }

  void _handleOnPressedSignUp() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (context, anim1, anim2) => SignUpPage()),
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    _handleOnTabBackButton();
    return Future.delayed(Duration.zero, () {
      _handleOnTabBackButton();
    });
  }

  void _handleOnTabBackButton() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => OnboardingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Image.asset(
              'lib/resources/images/background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              alignment: FractionalOffset(_animation.value, 0),
            ),
            SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Image.asset(
                            'lib/resources/images/icon-back.png',
                            fit: BoxFit.cover,
                            width: 32,
                            height: 32,
                          ),
                          onTap: _handleOnTabBackButton,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 120),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: username,
                      style: TextStyle(

                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'USERNAME',
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: password,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      obscureText: _obscureText,

                      decoration: InputDecoration(

                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        suffixIcon:  IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: (){
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      ),

                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 160),
            Positioned(
              left: 0,
              right: 0,
              top: (_signUpAnimation?.value ?? double.maxFinite) + 90,

              child: Column(

                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child: CustomButton(
                      onPressed: _handleOnPressedSignIn,
                      text: _isLoading ? 'Signing In':'Sign In',
                      highlight: true,
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  showAlertDialogs(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Auth Error"),
      content: Text("Wrong Username or Password."),
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

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
        content: Container(
          height: 40,
          child: new Row(
            children: [
              SpinKitFadingCircle(
                color: Colors.blueAccent,
                size: 40.0,
              ),
              Container(margin: EdgeInsets.only(left: 15),child:Text("Signing in" )),
            ],),
        )
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void _handleOnPressedSignIn() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'username' : username.text,
      'password' : password.text,
    };
    showAlertDialog(context);
    var res,body;

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    try{
        res = await CallApi().postData(data, 'login');
        body = json.decode(res.body);
        print(body);
        Navigator.of(context).pop();
        if(body['success']){
          localStorage.setString('token', body['token']);
          localStorage.setString('user', json.encode(body['user']));
          var userJson = localStorage.getString('user');
          var user = json.decode(userJson);
          print(user);
          Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, anim1, anim2) => NavigationHomeScreen()),
          );
        }
        else
        {
          showAlertDialogs(context);

        }

    }on NoSuchMethodError catch(e) {
      Toast.show("Please Contact System Administrator", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      Navigator.pop(context);
    }on TimeoutException catch(e){
      Toast.show("Connection Timeout", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      Navigator.pop(context);
    }catch(e){
      Toast.show("No Internet Connection", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      Navigator.pop(context);
    }
    finally{
      setState(() {
        _isLoading = false;
      });

    }


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

