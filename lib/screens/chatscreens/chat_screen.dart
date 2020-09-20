import 'package:astra/models/message.dart';
import 'package:astra/models/user.dart';
import 'package:astra/resources/firebase_repository.dart';
import 'package:astra/utils/universal_variables.dart';
import 'package:astra/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:astra/screens/chatscreens/modal_tile.dart";

import 'modal_tile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen(this.receiver);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  bool isWriting = false;
  User sender;
  String _currentUID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseRepository.getCurrentUser().then((value) {
      _currentUID = value.uid;

      setState(() {
        sender = User(
            uid: value.uid,
            name: value.displayName,
            profilePhoto: value.photoUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          showBottomIcons(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
    stream: Firestore.instance.collection("messages").
    document(_currentUID).collection(widget.receiver.uid).
    orderBy("timestamp", descending: false).snapshots(),
    builder: (ctx,AsyncSnapshot<QuerySnapshot> snap) {
      if(snap.data == null) {
        return Center(child: CircularProgressIndicator(),);
      }

      return ListView.builder(padding: EdgeInsets.all(10), itemCount: snap.data.documents.length ,itemBuilder: (ctxt, idx) {
        return chatMessageItem(snap.data.documents[idx]);
      });
    }
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        alignment: _message.senderId == _currentUID? Alignment.centerRight: Alignment.centerLeft,
        child:  _message.senderId == _currentUID? senderLayout(_message): receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget showBottomIcons() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Sharing Tools",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Photos",
                        subtitle: "Share Photos",
                        icon: Icons.image,
                      ),
                      ModalTile(
                        title: "Location",
                        subtitle: "Share your location",
                        icon: Icons.add_location,
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: UniversalVariables.goodGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: UniversalVariables.separatorColor,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.face),
                ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : Row(children: [
                  Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ]),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.goodGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 25,
                    ),
                    alignment: Alignment.center,
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  sendMessage() {
    var text = textFieldController.text;
    Message _message = Message(
        recieverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: "text"
        );

        setState(() {
          isWriting = false;
        });

        textFieldController.text = "";

        _firebaseRepository.addMessageToDb(_message, sender, widget.receiver);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
