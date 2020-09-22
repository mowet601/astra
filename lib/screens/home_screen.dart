import 'package:astra/provider/user_provider.dart';
import 'package:astra/screens/callscreens/pickup/pickup_layout.dart';
import 'package:astra/screens/pages/chat_list_screen.dart';
import 'package:astra/utils/universal_variables.dart';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _pageNo = 0;

  UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    // so that when you call the user is not set to null
    userProvider.refreshUser(); 
    });
    
    pageController = PageController();
  }

  void pageChanged(int page) {
    setState(() {
      _pageNo = page;
    });
  }

  void navTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
          scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: [
            Container(
              child: ChatListScreen(),
            ),
            Center(
              child: Text("Call Logs Here", style: TextStyle(color: Colors.white),),
            ),
            Center(
              child: Text("Contacts Here", style: TextStyle(color: Colors.white),),
            ),
          ],
          controller: pageController,
          onPageChanged: pageChanged,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: BottomNavigationBar(
              backgroundColor: UniversalVariables.blackColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_pageNo == 0
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                  ),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: 10.0,
                        color: (_pageNo == 0
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor)),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_pageNo == 1
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                  ),
                  title: Text(
                    "Call Logs",
                    style: TextStyle(
                        fontSize: 10.0,
                        color: (_pageNo == 1
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor)),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_pageNo == 2
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                  ),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: 10.0,
                        color: (_pageNo == 2
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor)),
                  ),
                ),
              ],
              onTap: navTapped,
              currentIndex: _pageNo,
            ),
          ),
        ),
      ),
    );
  }
}
