import 'package:astra/resources/firebase_repository.dart';
import 'package:astra/screens/home_screen.dart';
import 'package:astra/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    _firebaseRepository.signOut();

    return MaterialApp(
      title: "Astra",
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: _firebaseRepository.getCurrentUser(),
          builder: (ctx, AsyncSnapshot<FirebaseUser> snap) {
            if (snap.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
      ),
    );
  }
}
