import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addUser(Map<String, dynamic> user) async {
    try {
      await db.collection("users").add(user);

      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Stream<QuerySnapshot> getUsersByEmail(String email) {
    return db
    .collection("users")
    .where("email", isEqualTo: email)
    .snapshots();
  }
}
