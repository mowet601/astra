import 'package:astra/enum/user_state.dart';
import 'package:astra/provider/user_provider.dart';
import 'package:astra/resources/auth_methods.dart';
import 'package:astra/resources/local_db/repository/log_repository.dart';
import 'package:astra/screens/callscreens/pickup/pickup_layout.dart';
import 'package:astra/screens/pages/chat_list_screen.dart';
import 'package:astra/screens/pages/logs/log_screen.dart';
import 'package:astra/utils/universal_variables.dart';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _pageNo = 0;

  UserProvider userProvider;
  final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );

      LogRepository.init(
        isHive: true,
        dbName: userProvider.getUser.uid,
      );
    });

    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
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
            LogScreen(),
            Center(
              child: Text(
                "Contacts Here",
                style: TextStyle(color: Colors.white),
              ),
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
