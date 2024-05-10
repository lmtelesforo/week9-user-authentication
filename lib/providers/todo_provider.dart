/*
  Created by: Claizel Coubeili Cepe
  Date: updated April 26, 2023
  Description: Sample todo app with Firebase 
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_todo_api.dart';
import '../models/todo_model.dart';

class TodoListProvider with ChangeNotifier {
  FirebaseTodoAPI firebaseService = FirebaseTodoAPI();
  late Stream<QuerySnapshot> _todosStream;

  TodoListProvider() {
    fetchTodos();
  }

  Stream<QuerySnapshot> get todo => _todosStream;

  void fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    notifyListeners();
  }

  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson(item));
    print(message);
    notifyListeners();
  }

  void editTodo(String id, String newTitle) async {
    await firebaseService.editTodo(id, newTitle);
    notifyListeners();
  }

  void deleteTodo(String id) async {
    await firebaseService.deleteTodo(id);
    notifyListeners();
  }

  void toggleStatus(String id, bool status) async {
    await firebaseService.toggleStatus(id, status);
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchTodosofUser(String? email) async {
    if (email != null && email.isNotEmpty) {
      final snapshot = await firebaseService.getTodosByEmail(email).first;
      if (snapshot.docs.isNotEmpty) {
        final userTodos = snapshot.docs.first.data();
        return userTodos as Map<String, dynamic>; // get userTodos based on email
      } else {
        return null; // user not found
      }
    } 
    else {
      return null;
    }
  }

  bool stringToBool(String value) {  // converts bool to string
    value = value.toLowerCase();
    if (value == 'true') {
      return true;
    } 
    else if (value == 'false') {
      return false;
    }
    throw ArgumentError('Invalid: $value');
  }

  Map<String, dynamic> userTodos(String email, String title, String completed) { // created a structure for easier storing like firebase_provider ng userData
    Map<String, dynamic> newData = {
      'email': email,
      'title': title,
      'completed': stringToBool(completed)
    };
    return newData;
  }
}
