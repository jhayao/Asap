import 'dart:io';
import 'package:animated_background/src/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:animated_background/src/onboarding_page.dart';
import 'package:animated_background/src/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:splashscreen/splashscreen.dart';

import 'homePage/navigation_home_screen.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
void  main() async {
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //
  // runApp(AnimatedBackground());
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(AnimatedBackground()));
}

class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgoundState createState() => _AnimatedBackgoundState();
}

class _AnimatedBackgoundState extends State<AnimatedBackground>
{
  bool _isLoggedIn = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();

  }


  void _checkIfLoggedIn() async
  {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token= localStorage.getString('token');
    print(token);
    if(token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }
  // ignore: missing_return


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Background',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        child: FutureBuilder(
          future:InternetAddress.lookup("google.com"),
          builder: (context,snapshot){
            switch(snapshot.connectionState)
            {
              case ConnectionState.none:
                return Text("None");

            case ConnectionState.done:
              return AnimatedSplashScreen.withScreenFunction(
                splash: 'lib/resources/images/33.gif',
                duration: 3000,
                splashIconSize: 400,
                // nextScreen: OnboardingPage(),?
                screenFunction: () async{
                  if(snapshot.data==null)
                  {
                    Toast.show("No Internet Connection", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

                    return OnboardingPage();
                  }
                  else
                  {
                    return (!_isLoggedIn ? OnboardingPage() : NavigationHomeScreen());
                  }
                },
              );

              default:
                return OnboardingPage();
            }
    },

      ),

      ),

      debugShowCheckedModeBanner: false,

    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}



