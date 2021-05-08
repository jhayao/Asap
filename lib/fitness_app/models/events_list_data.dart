import 'dart:convert';
import 'dart:ui';

import 'package:animated_background/src/api/api.dart';

class EventsListData {
  EventsListData(
    this.imagePath,
    this.titleTxt ,
    this.fines,
    this.date,
    this.startColor,
    this.endColor ,
    {this.color}
  );

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> date;
  int fines;
  final Color color;

  Future<List> _getEvent()   async
  {
    var data = await CallApi().getData('getEvents');
    var jsonData =json.decode(data.body);
    return jsonData;
  }

  
}
