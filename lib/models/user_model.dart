import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class User {
  String? id;
  String firstname;
  String lastname;
  String email;

  User({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.email
  });

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email']
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User User) {
    return {
      'id': User.id,
      'firstname': User.firstname,
      'lastname': User.lastname,
      'email': User.email
    };
  }
}
