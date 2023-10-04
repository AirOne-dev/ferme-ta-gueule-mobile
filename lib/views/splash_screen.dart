import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FTG is starting...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            SpinKitPulse(
              color: Colors.white,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
