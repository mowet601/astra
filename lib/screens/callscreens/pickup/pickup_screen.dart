import 'package:astra/models/log.dart';
import 'package:astra/resources/local_db/repository/log_repository.dart';
import 'package:astra/screens/callscreens/call_screen.dart';
import 'package:astra/screens/chatscreens/cached_image.dart';
import 'package:astra/utils/permissions.dart';
import 'package:astra/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:astra/models/call.dart';
import 'package:astra/resources/call_methods.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCallMissed = true;

  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    if (isCallMissed) {
      addToLocalStorage(callStatus: "missed");
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Start ringtone.
    FlutterRingtonePlayer.playRingtone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming Call",
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Inconsolata",
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 100,
            ),
            SizedBox(height: 50),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Lato",
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: "received");
                    FlutterRingtonePlayer.stop();
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: "received");
                      FlutterRingtonePlayer.stop();
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CallScreen(call: widget.call),
                              ),
                            )
                          : {};
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
