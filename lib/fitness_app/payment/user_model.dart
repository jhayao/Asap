class UserModel {
  final String id;
  final String studentNumber;
  final String name;
  final String avatar;

  UserModel(
      {this.id, this.studentNumber, this.name, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["studentnumber"],
      studentNumber:
      json["studentnumber"],
      name: json["name"],
      avatar: 'https://ssc.codes/storage/' +  json["avatar"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }
  bool isEqual(UserModel model) {
    return this.id == model?.id;
  }

  @override
  String toString() => studentNumber;
}