import 'package:astra/resources/firebase_repository.dart';
import 'package:astra/screens/search_screen.dart';
import 'package:astra/utils/universal_variables.dart';
import 'package:astra/utils/utilities.dart';
import 'package:astra/widgets/chat_list_container.dart';
import 'package:astra/widgets/custom_appbar.dart';
import 'package:astra/widgets/user_circle.dart';
import "package:flutter/material.dart";

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  String currentUserId;
  String initials;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((value) {
      setState(() {
        currentUserId = value.uid;
        initials = Utils.getInitials(value.displayName);
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(initials),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(seconds: 1),
                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
                  animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

                  return ScaleTransition(alignment: Alignment.topRight, scale: animation, child: child);
                },
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
                  return SearchScreen();
                }
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(currentUserId),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: UniversalVariables.goodGradient,
          borderRadius: BorderRadius.circular(50)),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
