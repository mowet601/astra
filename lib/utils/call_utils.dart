import 'dart:math';

import 'package:astra/models/log.dart';
import 'package:astra/resources/local_db/repository/log_repository.dart';
import 'package:flutter/material.dart';
import 'package:astra/models/call.dart';
import 'package:astra/models/user.dart';
import 'package:astra/resources/call_methods.dart';
import 'package:astra/screens/callscreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  // from -> caller ; to-> receiver
  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: "dialled",
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    // because hasCalled property has been made in the makeCall method
    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      LogRepository.addLogs(log);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}