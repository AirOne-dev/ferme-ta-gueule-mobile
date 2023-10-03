import 'ftg.dart';

import '../main.dart';
import '../views/log_screen.dart';

class Globals {
  static FTG ftg = FTG();
  static var routes = {
    '/': (context) => MyApp(),
    '/index/logs': (context) => LogScreen(
          logs: Globals.ftg.logsByTabIndex[0] ?? [],
          title: 'FTG - Logs',
          ftg: Globals.ftg,
        ),
  };
}
