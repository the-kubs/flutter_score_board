import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppVersionSplashScreenPage extends StatefulWidget {
  const AppVersionSplashScreenPage({super.key});

  @override
  State<AppVersionSplashScreenPage> createState() =>
      _AppVersionSplashScreenPageState();
}

class _AppVersionSplashScreenPageState
    extends State<AppVersionSplashScreenPage> {
  static const platform = MethodChannel('com.example.app/version');
  String flutterVersionName = "Loading...";
  // String _appVersion = "";
  @override
  void initState() {
    super.initState();
    // _getAppVersion();
    _getFlutterVersionName();
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

  Future<void> _getFlutterVersionName() async {
    try {
      final String result =
          await platform.invokeMethod('getFlutterVersionName');
      setState(() {
        flutterVersionName = result;
      });
    } catch (e) {
      setState(() {
        flutterVersionName = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  20.0), // Ganti 20.0 dengan radius yang Anda inginkan

              child: Image.asset(
                'assets/images/playstore.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              flutterVersionName,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
