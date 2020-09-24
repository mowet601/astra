import 'package:flutter/material.dart';
import 'package:astra/models/log.dart';
import 'package:astra/resources/local_db/repository/log_repository.dart';
import 'package:astra/utils/universal_variables.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Center(
        child: FlatButton(
          child: Text("Click Me", style: TextStyle(color: Colors.white),),
          onPressed: () {
            LogRepository.init(isHive: false);
            LogRepository.addLogs(Log());
          },
        ),
      ),
    );
  }
}