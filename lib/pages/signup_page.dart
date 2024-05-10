import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/api/firebase_auth_api.dart';
import 'package:week9_authentication/providers/firebase_provider.dart';
import '../providers/auth_provider.dart';
import 'package:email_validator/email_validator.dart';
import '../providers/firebase_provider.dart'; 

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  late String signUpResult;
  late Map<String, dynamic> user;

  bool validateStructure(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  } // thank you to my reference i owe u my life

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [heading, firstnameField, lastnameField, emailField, passwordField, submitButton] // added more fields for last name and first name
              ),
            )),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get firstnameField => Padding( // field for first name
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("First name"),
              hintText: "Enter your first name"),
          onSaved: (value) => setState(() => firstname = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your first name";
            }
            if (value == "" || value.trim().isEmpty) {
              return "Please enter your first name";
            } // additional checkers for null inputs
            return null;
          },
        ),
      );

  Widget get lastnameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Last name"),
              hintText: "Enter your last name"),
          onSaved: (value) => setState(() => lastname = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your last name";
            }
            if (value == "" || value.trim().isEmpty) {
              return "Please enter your last name";
            } // additional checkers for null inputs
            return null;
          },
        ),
      );

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
              hintText: "Enter a valid email"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid email";
            }
            if ((EmailValidator.validate(value)) != true) { // call email validator function from email validator package to check email format
              return "Please enter a valid email format (e.g. xxx@xxx.com)";
            }
            if (value == "" || value.trim().isEmpty) {
              return "Please enter a valid email";
            } // additional checkers for null inputs
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              hintText: "At least 6 characters"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid password";
            }
            if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            if (validateStructure(value) != true) { // call password format regex checker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password must have at least 1 small letter, 1 capital letter, 1 digit, and 1 special character')),
              ); // show correct format guide
              return "Password format invalid";
            }
            if (value == "" || value.trim().isEmpty) {
              return "Please enter a valid password";
            } // additional checkers for null inputs
            return null;
          },
        ),
      );

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          // declare all variables from above
          final firstName = firstname!;
          final lastName = lastname!;
          final userEmail = email!;
          final userPassword = password!;

          final user = UserInfosProvider().userData(firstName, lastName, userEmail); // call function from UserInfosProvider or firebase_provider to save all data in a Map<String, dynamic>

          final authService = Provider.of<UserAuthProvider>(context, listen: false).authService; // declare providers para magamit yung individual functions nila
          final userInfos = Provider.of<UserInfosProvider>(context, listen: false);

          // check if sign up was successful authService side (auth_provider)
          signUpResult = (await authService.signUp(firstName, lastName, userEmail, userPassword))!; // gets string message

          if (signUpResult == 'The account already exists for that email.') { // match error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Account already exists!')),
            );
          }
          else {
            // successful, call function from UserInfosProvider 
            userInfos.addUser(user);

            // check if the widget hasn't been disposed of after an asynchronous action
            if (mounted) { // successful, pop current page
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User signed up successfully!')),
              );
            }
          }
        }
      },
      child: const Text("Sign Up"));
}
