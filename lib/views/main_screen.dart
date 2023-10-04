import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:ferme_ta_gueule_mobile/class/ftg.dart';
import 'package:ferme_ta_gueule_mobile/views/empty_screen.dart';

class MainScreen extends StatefulWidget {
  final FTG ftg;

  const MainScreen({required this.ftg, Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    // update the UI when the stream emits a new value
    // (when a new log is received)
    subscription = widget.ftg.stream.listen((_) {
      setState(() {});
    });

    widget.ftg.tabController.addListener(() async {
      var currrentFtgRoute = '';
      try {
        currrentFtgRoute = widget.ftg.routes.keys.toList()[widget.ftg.tabController.index];
      } catch (_) {}

      if (currrentFtgRoute.contains('/index/')) {
        final selectedFtgIndex = currrentFtgRoute.split('/')[2];

        widget.ftg.isFetchingLogs = false;
        widget.ftg.sendCommand('index $selectedFtgIndex');
        widget.ftg.isFetchingLogs = true;
      }
    });
  }

  @override
  void dispose() {
    widget.ftg.stop();
    subscription?.cancel();
    widget.ftg.controller.close();
    widget.ftg.stream.drain();
    widget.ftg.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          ...(widget.ftg.routes.keys.toList().isNotEmpty
              ? widget.ftg.routes.keys
                  .toList()
                  .map((route) => BottomNavigationBarItem(
                        label: route.split('/')[2],
                        icon: const Icon(CupertinoIcons.ant_circle),
                      ))
                  .toList()
              : [
                  const BottomNavigationBarItem(
                    label: 'empty',
                    icon: Icon(CupertinoIcons.infinite),
                  )
                ]),
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
              ftgIndexTabs = widget.ftg.routes[widget.ftg.routes.keys.toList()[index]];
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
