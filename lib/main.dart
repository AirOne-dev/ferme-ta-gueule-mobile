import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ferme_ta_gueule_mobile/class/globals.dart';

import 'class/ftg.dart';
import 'views/empty_screen.dart';
import 'views/log_screen.dart';

final ROUTES = {
  '/': (context) => MyApp(),
  '/index/logs': (context) => LogScreen(
        logs: Globals.ftg.logsByTabIndex[0] ?? [],
        title: 'FTG - Index logs',
        ftg: Globals.ftg,
      ),
  '/index/gql': (context) => LogScreen(
        logs: Globals.ftg.logsByTabIndex[1] ?? [],
        title: 'FTG - Index gql',
        ftg: Globals.ftg,
      ),
};
void main() {
  runApp(CupertinoApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: ROUTES,
    // theme: CupertinoThemeData(
    //   brightness: Brightness.dark,
    // ),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  final FTG ftg = Globals.ftg;
  late StreamSubscription? subscription;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.subscription = widget.ftg.stream.listen((_) {
      // update the UI when the stream emits a new value
      // (when a new log is received)
      setState(() {});
    });

    widget.ftg.tabController.addListener(() async {
      widget.ftg.isFetchingLogs = false;
      switch (widget.ftg.tabController.index) {
        case 0:
          await widget.ftg.sendCommand('index logs');
          break;
        case 1:
          await widget.ftg.sendCommand('index gql');
          break;
        default:
          break;
      }
      widget.ftg.isFetchingLogs = true;
    });
  }

  @override
  void dispose() {
    widget.ftg.stop();
    widget.subscription?.cancel();
    widget.ftg.controller.close();
    widget.ftg.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Logs',
            icon: Icon(CupertinoIcons.ant_circle),
          ),
          BottomNavigationBarItem(
            label: 'Gql',
            icon: Icon(CupertinoIcons.graph_circle),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return ROUTES['/index/logs']!(context);
              case 1:
                return ROUTES['/index/gql']!(context);
              default:
                return EmptyScreen(status: widget.ftg.status);
            }
          },
        );
      },
      controller: widget.ftg.tabController,
    );
  }
}
