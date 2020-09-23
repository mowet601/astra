import 'package:astra/models/user.dart';
import 'package:astra/resources/auth_methods.dart';
import 'package:astra/screens/callscreens/pickup/pickup_layout.dart';
import 'package:astra/screens/chatscreens/chat_screen.dart';
import 'package:astra/utils/universal_variables.dart';
import 'package:astra/widgets/custom_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search-screen";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthMethods _authMethods = AuthMethods();

  List<User> userList;
  String searchedText = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authMethods.getCurrentUser().then((FirebaseUser user) {
      _authMethods.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchBar(BuildContext context) {
     return GradientAppBar(
      backgroundColorStart: UniversalVariables.gradientColorStart,
      backgroundColorEnd: UniversalVariables.gradientColorEnd,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                searchedText = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: searchedText == ""? Container()  : Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                  setState(() {
                    searchedText = "";
                  });
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String searchUser) {
    final List<User> suggestionsList = searchUser.isEmpty
        ? []
        : userList.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _searchText = searchUser.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_searchText);
            bool matchesName = _getName.contains(_searchText);

            // email -> namanrivaan@gmail.com
            // username -> namanrivaan
            // name -> Optimum Setups (Google Name)

            return (matchesUsername || matchesName);
          }).toList();

    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((ctx, idx) {
        User searchedUser = User(
            uid: suggestionsList[idx].uid,
            profilePhoto: suggestionsList[idx].profilePhoto,
            name: suggestionsList[idx].name,
            username: suggestionsList[idx].username
          );

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ChatScreen(searchedUser)));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(color: UniversalVariables.greyColor),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: searchBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(searchedText),
        ),
      ),
    );
  }
}