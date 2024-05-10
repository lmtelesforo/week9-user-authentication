import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/api/firebase_users_api.dart';
import 'package:week9_authentication/providers/auth_provider.dart';
import '../providers/firebase_provider.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  User? user;
  late String userEmail;
  late Future<Map<String, dynamic>?> userData;

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  void getUserEmail() {
    // current user from UserAuthProvider
    user = context.read<UserAuthProvider>().user;
    // user's email 
    userEmail = user!.email!;
    userData = context.read<UserInfosProvider>().fetchCurrentUser(userEmail); // get userData of current user (firebase_provider function)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } 
          else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } 
          else {
            final userData = snapshot.data; // initialize ulit yung naload sa taas
            if (userData != null) {
              // print userData
              final String firstname = userData['firstname'];
              final String lastname = userData['lastname']; // get from userData keys
              return Container(
                margin: EdgeInsets.all(30),
                child: Center(
                  child: Column(
                    children: [
                      Text( // display values
                        "First name: $firstname",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Last name: $lastname",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Email: ${user!.email!}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            } 
            else {
              return const Center(
                child: Text('User data not found'),
              ); // in case it doesn't load
              // but it will [need lang ng pangcatch]
            }
          }
        },
      ),
    );
  }
}
