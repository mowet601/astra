import 'package:astra/models/contact.dart';
import 'package:astra/provider/user_provider.dart';
import 'package:astra/resources/chat_methods.dart';
import 'package:astra/screens/search_screen.dart';
import 'package:astra/utils/universal_variables.dart';
import 'package:astra/widgets/contact_view.dart';
import 'package:astra/widgets/custom_appbar.dart';
import 'package:astra/widgets/logs_appbar.dart';
import 'package:astra/widgets/new_chat_button.dart';
import 'package:astra/widgets/quiet_box.dart';
import 'package:astra/widgets/user_circle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: LogsAppBar(
        title: UserCircle(),
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
      ),
      floatingActionButton: NewChatButton(),
      body: RefreshIndicator(
          onRefresh: () async => await userProvider.refreshUser(),
          child: ChatListContainer()),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox(
                  heading: "Contacts",
                  subtitle:
                      "Search For Friends and Family!",
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);
                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
