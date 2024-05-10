import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_users_api.dart';
import '../models/user_model.dart';

// created provider for storing user details (details page)
class UserInfosProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();
  late Stream<QuerySnapshot> _userStream;

  UserInfosProvider() {
    fetchUsers();
  }

  Stream<QuerySnapshot> get allUsers => _userStream;
  
  void fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchCurrentUser(String? email) async { // get current user and their first and last name + email
    if (email != null && email.isNotEmpty) {
      final snapshot = await firebaseService.getUsersByEmail(email).first;
      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data();
        return userData as Map<String, dynamic>;
      } else {
        return null; // user is not found
      }
    } else {
      return null; // in case email  is empty
      // catch
    }
  }

  void addUser(Map<String, dynamic> user) async { // add user to firebase
    String? message = await firebaseService.addUser(user);
    print(message); 
    notifyListeners(); 
  }
  
  Map<String, dynamic> userData(String firstname, String lastname, String email) { // created a structure for easier storing
    Map<String, dynamic> newData = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email // with required fields
    };
    return newData;
  }
}
