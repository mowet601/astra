import 'dart:io';
import 'package:astra/enum/view_state.dart';
import 'package:astra/models/message.dart';
import 'package:astra/models/user.dart';
import 'package:astra/provider/image_upload_provider.dart';
import 'package:astra/provider/user_provider.dart';
import 'package:astra/resources/auth_methods.dart';
import 'package:astra/resources/chat_methods.dart';
import 'package:astra/resources/storage_methods.dart';
import 'package:astra/screens/callscreens/pickup/pickup_layout.dart';
import 'package:astra/screens/chatscreens/cached_image.dart';
import 'package:astra/screens/chatscreens/full_image_screen.dart';
import 'package:astra/utils/call_utils.dart';
import 'package:astra/utils/permissions.dart';
import 'package:astra/utils/universal_variables.dart';
import 'package:astra/utils/utilities.dart';
import 'package:astra/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import "package:astra/screens/chatscreens/modal_tile.dart";
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'modal_tile.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  ChatScreen(this.receiver);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ImageUploadProvider _imageUploadProvider;
  ScrollController _listViewController = ScrollController();
  TextEditingController textFieldController = TextEditingController();
  final StorageMethods _storageMethods = StorageMethods();
  final ChatMethods _chatMethods = ChatMethods();
  final AuthMethods _authMethods = AuthMethods();
  bool isWriting = false;
  FocusNode inputTextFieldFocus = FocusNode();
  bool showEmojiPicker = false;
  User sender;
  String _currentUID;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authMethods.getCurrentUser().then((value) {
      _currentUID = value.uid;

      setState(() {
        sender = User(
            uid: value.uid,
            name: value.displayName,
            profilePhoto: value.photoUrl);
      });
    });
  }

  showKeyboard() => inputTextFieldFocus.requestFocus();
  hideKeyboard() => inputTextFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return PickupLayout(
        scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
             _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            showBottomIcons(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  Widget messageList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("messages")
            .document(_currentUID)
            .collection(widget.receiver.uid)
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snap) {
          if (snap.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _listViewController.jumpTo(
                _listViewController.position.maxScrollExtent
          );
          });

          return ListView.builder(
                padding: EdgeInsets.all(10),
                controller: _listViewController,
                itemCount: snap.data.documents.length,
                itemBuilder: (ctxt, idx) {
                  return chatMessageItem(snap.data.documents[idx]);
                });
        });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        alignment: _message.senderId == _currentUID
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUID
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }
  
  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _storageMethods.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUID,
        imageUploadProvider: _imageUploadProvider,
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
    return message.type != "image"?
    Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      )
    ) : GestureDetector(onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullImageScreen(message.photoUrl,),)),
          child: Hero(tag: message.photoUrl,child: CachedImage(message.photoUrl, height: 250, width: 250, radius: 10,)));
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
                        onPressed: () {
                          pickImage(source: ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
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
            child: Stack(
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: inputTextFieldFocus,
                  onTap: () => hideEmojiContainer(),
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
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        if(!showEmojiPicker) {
                          hideKeyboard();
                          showEmojiContainer();
                        } else {
                          showKeyboard();
                          hideEmojiContainer();
                        }
                      },
                      icon: Icon(Icons.face, color: Colors.white,),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Row(children: [
                  GestureDetector(
                    onTap: () => pickImage(source: ImageSource.camera),
                      child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
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
        type: "text");

    setState(() {
      isWriting = false;
    });

    textFieldController.text = "";

    _chatMethods.addMessageToDb(_message, sender, widget.receiver);
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
          onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted()? CallUtils.dial(from: sender, to: widget.receiver, context: context) : {},
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