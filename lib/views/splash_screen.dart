import 'dart:ui';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ferme_ta_gueule_mobile/class/ftg.dart';

class SplashScreen extends StatefulWidget {
  final FTG ftg;
  final String message;

  const SplashScreen({required this.ftg, this.message = 'FTG is starting...', Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> waitForFtgToStart() async {
    if (widget.ftg.routes.isEmpty || widget.ftg.status == {}) {
      await Future.delayed(const Duration(milliseconds: 1000));
      return waitForFtgToStart(); // Recursively call itself after a delay
    }
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'ftg': widget.ftg,
    });
  }

  @override
  void initState() {
    super.initState();
    waitForFtgToStart();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDarkMode = brightness == Brightness.dark;

    ScrollController scrollController = ScrollController();

    Text fakeLog = () {
      var list = ['INFO', 'WARN', 'ERROR', 'DEBUG'];
      list.shuffle();
      return Text(
        '${faker.date.dateTime().toIso8601String()} ${list[0]} Server log ${faker.lorem.sentence()}',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      );
    }();

    List<Text> fakeLogs = List.generate(
      150,
      (index) => fakeLog,
    );

    void scrollLoop() async {
      // random delay between 100 and 750 ms
      await Future.delayed(Duration(milliseconds: Random().nextInt(750 - 100) + 100));
      scrollController.animateTo(
        scrollController.offset + 10.0,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      );
      fakeLogs.add(fakeLog);
      return scrollLoop();
    }

    scrollLoop();

    return Scaffold(
      backgroundColor: isDarkMode ? CupertinoColors.darkBackgroundGray : CupertinoColors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: fakeLogs,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: Text(
                widget.message,
                style: TextStyle(
                  color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
