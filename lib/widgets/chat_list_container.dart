import 'package:astra/utils/universal_variables.dart';
import 'package:astra/widgets/custom_tile.dart';
import "package:flutter/material.dart";

class ChatListContainer extends StatefulWidget {
  final String currentUserId;

  ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (ctx, index) {
          return CustomTile(
            mini: false,
            onTap: () {},
            title: Text(
              // name of the peer users
              "Name Of The User",
              style: TextStyle(
                  color: Colors.white, fontFamily: "Arial", fontSize: 17, fontWeight: FontWeight.w800),
            ),
            
            subtitle: Text(
              // last message of the peer users
              "Last Message",
              style: TextStyle(
                color: UniversalVariables.greyColor,
                fontSize: 14,
              ),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    // image of the peer users
                    backgroundImage: NetworkImage("https://i.pinimg.com/originals/3f/3d/d9/3f3dd9219f7bb1c9617cf4f154b70383.jpg"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 13,
                      width: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UniversalVariables.onlineDotColor,
                        border: Border.all(
                          color: UniversalVariables.blackColor,
                          width: 2
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}