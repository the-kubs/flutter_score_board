import 'dart:async';
import 'package:flutter/material.dart';

class AppVersionSplashScreenPage extends StatefulWidget {
  const AppVersionSplashScreenPage({super.key});

  @override
  State<AppVersionSplashScreenPage> createState() =>
      _AppVersionSplashScreenPageState();
}

class _AppVersionSplashScreenPageState
    extends State<AppVersionSplashScreenPage> {
  String _appVersion = "";
  @override
  void initState() {
    super.initState();
    // _getAppVersion();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  // Future<void> _getAppVersion() async {
  //   final info = await PackageInfo.fromPlatform();
  //   setState(() {
  //     _appVersion = "Version: ${info.version} (${info.buildNumber})";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/playstore.jpg', width: 200, height: 200),
            const SizedBox(height: 20),
            const Text(
              'V1.0.0',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
