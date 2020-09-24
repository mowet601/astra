import 'package:flutter/material.dart';
import 'package:astra/screens/search_screen.dart';
import 'package:astra/utils/universal_variables.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Contacts",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: "Lato",
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Search For Friends and Family!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 25),
              RaisedButton(
                elevation: 5.0,
                color: UniversalVariables.lightBlueColor,
                child: Text("Start Searching!"),
                onPressed: () => Navigator.of(context).push(
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 1),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimation,
                          Widget child) {
                        animation = CurvedAnimation(
                            parent: animation, curve: Curves.elasticInOut);

                        return ScaleTransition(
                            alignment: Alignment.topRight,
                            scale: animation,
                            child: child);
                      },
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secAnimation) {
                        return SearchScreen();
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//do somethign
