import 'dart:convert';

import 'package:animated_background/src/api/api.dart';

class StudentsListData {
  StudentsListData(
      this.studentNumber,
      this.lastName ,
      this.firstName ,
      this.middleName ,
      this.fullName,
      this.imagePath,
      this.course
      );

  String studentNumber;
  String lastName;
  String firstName;
  String middleName;
  List<String> fullName;
  String imagePath;
  String course;




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
