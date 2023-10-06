import 'dart:async';
import 'package:ferme_ta_gueule_mobile/class/utils.dart';
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

    ftgStatusLoop();
  }

  // This function is called recursively until the status is empty
  void ftgStatusLoop() async {
    if (widget.ftg.status.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      return ftgStatusLoop(); // Recursively call itself after a delay
    }

    widget.ftg.stop().then((_) {
      Navigator.pushReplacementNamed(context, '/', arguments: {
        'ftg': FTG(),
        'message': 'FTG is reloading...',
      });
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
                        icon: Icon(
                          Utils.iconFromFirstLetter(route.split('/')[2]),
                        ),
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
            Widget Function(BuildContext bc)? ftgIndexTab;
            try {
              ftgIndexTab = widget.ftg.routes[widget.ftg.routes.keys.toList()[index]];
            } catch (_) {}
            if (ftgIndexTab != null) {
              return ftgIndexTab(context);
            }
            return EmptyScreen(status: widget.ftg.status, ftg: widget.ftg);
          },
        );
      },
      controller: widget.ftg.tabController,
    );
  }
}
