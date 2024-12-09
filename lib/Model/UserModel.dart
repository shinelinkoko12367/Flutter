// lib/models/user.dart
class User {
  String? id;
  String? title;
  String? desc;

  User({this.id, this.title, this.desc});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'email': desc,
    };
  }
}
