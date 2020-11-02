import 'dart:convert';

import 'package:animated_background/src/api/api.dart';

class EventsListData {
  EventsListData(
    this.imagePath,
    this.titleTxt ,
    this.fines,
    this.date,
    this.startColor,
    this.endColor ,
  );

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> date;
  int fines;

  Future<List> _getEvent()   async
  {
    var data = await CallApi().getData('getEvents');
    var jsonData =json.decode(data.body);
    return jsonData;
  }

  // List<MealsListData> tabIconsList = <MealsListData>[];


  // static List<EventsListData> tabIconsList = <EventsListData>[
  //   EventsListData(
  //      'assets/fitness_app/breakfast.png',
  //     'Breakfast',
  //     525,
  //     <String>['Bread,', 'Peanut butter,', 'Apple'],
  //     '#FA7D82',
  //     '#FFB295',
  //   ),
  //   EventsListData(
  //     'assets/fitness_app/lunch.png',
  //     'Lunch',
  //     602,
  //     <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
  //     '#738AE6',
  //     '#5C5EDD',
  //   ),
  //   MealsListData(
  //     'assets/fitness_app/snack.png',
  //     'Snack',
  //     0,
  //     <String>['Recommend:', '800 kcal'],
  //     '#FE95B6',
  //     '#FF5287',
  //   ),
  //   MealsListData(
  //     'assets/fitness_app/dinner.png',
  //     'Dinner',
  //      0,
  //     <String>['Recommend:', '703 kcal'],
  //     '#6F72CA',
  //      '#1E1466',
  //   ),
  // ];
}
