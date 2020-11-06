// import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';
// import 'package:best_flutter_ui_templates/fitness_app/asap_app_home_screen.dart';
// import 'package:best_flutter_ui_templates/hotel_booking/hotel_home_screen.dart';
import 'package:animated_background/fitness_app/asap_app_home_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [

    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: AsapAppHomeScreen(),
    ),

  ];
}
