import 'package:ferme_ta_gueule_mobile/class/ftg.dart';
import 'package:flutter/cupertino.dart';

import 'views/main_screen.dart';
import 'views/splash_screen.dart';

void main() {
  FTG ftg = FTG();

  runApp(CupertinoApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(ftg: ftg),
      '/home': (context) => MainScreen(ftg: ftg),
      ...ftg.routes,
    },
    // theme: CupertinoThemeData(
    //   brightness: Brightness.dark,
    // ),
  ));
}
