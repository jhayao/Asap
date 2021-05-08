import 'dart:io';

import 'package:animated_background/src/custom_button.dart';
import 'package:animated_background/src/login_page.dart';
import 'package:animated_background/src/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class OnboardingPage extends StatefulWidget {
  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation<double> _backgroundAnimation;

  @override
  void initState()  {
    _checkToken();
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));

    _backgroundAnimation =
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

    _animationController.forward();
  }
   void _checkToken() async{
     SharedPreferences localStorage = await SharedPreferences.getInstance();
     var token= localStorage.getString('token');

   }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleOnPressedSignUp() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (context, anim1, anim2) => SignUpPage()),
    );
  }

  void _handleOnPressedSignIn() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (context, anim1, anim2) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            'lib/resources/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(_backgroundAnimation.value, 0),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'lib/resources/images/ssc2.png',
                        width: 150,
                        height: 150,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Text(
                    'Supreme Student Council Attendance System',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -2,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                CustomButton(
                  text: 'Quick Balance',
                  highlight: true,
                  onPressed: _handleOnPressedSignUp,
                ),
                SizedBox(height: 16),
                CustomButton(
                  text: 'Sign in',
                  highlight: true,
                  onPressed: _handleOnPressedSignIn,
                ),

                SizedBox(height: 150),
              ],
            ),
          )
        ],
      ),
    );
  }
}
