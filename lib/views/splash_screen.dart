import 'dart:ui';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ferme_ta_gueule_mobile/class/ftg.dart';

class SplashScreen extends StatefulWidget {
  final FTG ftg;

  const SplashScreen({required this.ftg, Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> waitForFtgToStart() async {
    if (widget.ftg.routes.isEmpty || widget.ftg.status == {}) {
      await Future.delayed(const Duration(milliseconds: 1000));
      return waitForFtgToStart(); // Recursively call itself after a delay
    }
    Navigator.pushReplacementNamed(context, '/home');
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

    return Scaffold(
      backgroundColor: isDarkMode ? CupertinoColors.darkBackgroundGray : CupertinoColors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1.5, // making it longer than screen height
              child: Column(
                children: List.generate(
                  100,
                  (index) {
                    var list = ['INFO', 'WARN', 'ERROR', 'DEBUG'];
                    list.shuffle();
                    return Text(
                      '${faker.date.dateTime().toIso8601String()} ${list[0]} Server log ${faker.lorem.sentence()}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: Text(
                "FTG is starting...",
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
