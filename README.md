# CMSC 23 Week 9: User Authentication using Firebase

**Name:** Laira Claire M. Telesforo <br/>
**Section:** U-4L <br/>
**Student number:** 2021-13059 <br/>

## Code Description
This is a simple todo app that's connected to a Firebase Cloud Firestore. It can perform user authentication using Firebase.

## Things you did in the code
- made a model for users
- added a firebase_users_api
- used email as the unique identifier for displaying the todos made by the current user
- made firebase_provider to store the functions for implementing CRUD operations on Firebase

## Challenges encountered
- understanding how to connect authentication with the Firestore database
- at first, I did not know if I should create another provider for users or if I should just add it to the provider for the todos
- I previously was having trouble regarding checking if email already exists in the Firebase authentication
- saving the userEmail and using it for the whole implementation

## Commit Log
1. Initial commit
2. feat: added first name and last name fields with proper validation condition
3. feat: added user_model.dart
4. feat: added a email validator functions to signin and signup pages
5. created a firebase_provider.dart for user data manipulation on Firebase
6. created firebase_users_api.dart
7. feat: todo list changes based on signed in user using email as its identifier
8. feat: added a password validator for sign in as well
9. modified README file

## References
- https://pub.dev/packages/email_validator
- https://stackoverflow.com/questions/68226712/how-to-check-if-string-contains-both-uppercase-and-lowercase-characters
- Provider.of part: https://stackoverflow.com/questions/70552293/how-to-declare-multiprovider-in-some-other-class-than-main-dart 