import 'package:astra/utils/universal_variables.dart';
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _pageNo = 0;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        children: [
          Center(
            child: Text("Chats Here", style: TextStyle(color: Colors.white),),
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
    );
  }
}
