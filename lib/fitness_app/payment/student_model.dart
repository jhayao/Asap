import 'dart:convert';
import 'dart:ui';

import 'package:animated_background/src/api/api.dart';

class StudentModel {
  StudentModel(
      this.avatar,
      this.id,
      this.name,
      this.username,
      );

  String avatar;
  String id;
  String name;
  String username;
}