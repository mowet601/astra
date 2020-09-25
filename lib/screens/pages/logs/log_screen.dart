import 'package:astra/screens/callscreens/pickup/pickup_layout.dart';
import 'package:astra/screens/search_screen.dart';
import 'package:astra/widgets/floating_column.dart';
import 'package:astra/widgets/log_list_container.dart';
import 'package:astra/widgets/logs_appbar.dart';
import 'package:flutter/material.dart';
import 'package:astra/models/log.dart';
import 'package:astra/resources/local_db/repository/log_repository.dart';
import 'package:astra/utils/universal_variables.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: LogsAppBar(
          title: "Calls",
          actions: [
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
          ],
        ),
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
