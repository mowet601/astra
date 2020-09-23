import 'package:astra/provider/image_upload_provider.dart';
import 'package:astra/provider/user_provider.dart';
import 'package:astra/resources/auth_methods.dart';
import 'package:astra/screens/home_screen.dart';
import 'package:astra/screens/login_screen.dart';
import 'package:astra/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider(),),
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
          child: MaterialApp(
        title: "Astra",
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          SearchScreen.routeName : (ctx) => SearchScreen(), 
        },
        home: FutureBuilder(
            future: _authMethods.getCurrentUser(),
            builder: (ctx, AsyncSnapshot<FirebaseUser> snap) {
              if (snap.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            },
        ),
      ),
    );
  }
}
