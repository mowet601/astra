import 'package:astra/resources/firebase_repository.dart';
import 'package:astra/screens/home_screen.dart';
import 'package:astra/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: [
          Center(
            child: loginButton(),
          ),
          isLoginPressed? Center(child: CircularProgressIndicator(),) : Container(),
        ],
      ),
    );
  }

  Widget loginButton() {
    return GoogleSignInButton(
      onPressed: () => performLogin(),
      darkMode: true,
    );
  }

  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.signIn().then((FirebaseUser user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print("There was an error");
        setState(() {
          isLoginPressed = false;
        });
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    _repository.authenticateUser(user).then((value) {
      setState(() {
        isLoginPressed = false;
      });
      
      if (value) {
        _repository.addDataToDb(user).then((value) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
