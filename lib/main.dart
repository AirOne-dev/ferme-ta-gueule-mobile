import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:ferme_ta_gueule_mobile/class/globals.dart';

import 'class/ftg.dart';
import 'views/empty_screen.dart';
import 'views/log_screen.dart';

void main() {
  runApp(CupertinoApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: Globals.routes,
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
      var currrentRoute = '';
      try {
        currrentRoute = Globals.routes.keys.toList()[widget.ftg.tabController.index + 1];
      } catch (_) {}

      if (currrentRoute.contains('/index/')) {
        final selectedFtgIndex = currrentRoute.split('/')[2];

        widget.ftg.isFetchingLogs = false;
        widget.ftg.sendCommand('index $selectedFtgIndex');
        widget.ftg.isFetchingLogs = true;
      }
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
        items: [
          ...Globals.routes.keys
              .toList()
              .map((route) => route.contains('/index/')
                  ? BottomNavigationBarItem(
                      label: route.split('/')[2],
                      icon: const Icon(CupertinoIcons.ant_circle),
                    )
                  : null)
              .toList()
              .nonNulls,
          const BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(CupertinoIcons.settings),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            var ftgIndexTabs = null;
            try {
              ftgIndexTabs = Globals.routes[Globals.routes.keys.toList()[index + 1]];
            } catch (_) {}
            if (ftgIndexTabs != null) {
              return ftgIndexTabs(context);
            }
            return EmptyScreen(status: widget.ftg.status);
          },
        );
      },
      controller: widget.ftg.tabController,
    );
  }
}
