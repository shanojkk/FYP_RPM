// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/main.dart';
import 'package:vitalrpm/screens/auth/login_screen.dart';

import 'const/storage_keys.dart';
import 'providers/common_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  SplashScreenState() {
    Timer(const Duration(milliseconds: 4800), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  late CommonProvider _commonProvider;
  @override
  void initState() {
    _commonProvider = context.read<CommonProvider>();
    checkPreferences();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Locale temp;
    if (prefs.containsKey(StorageKeys.LanguageCode)) {
      final String? languageCode = prefs.getString(StorageKeys.LanguageCode);
      if (languageCode == "si") {
        temp = const Locale("si", "LK");
      } else {
        temp = const Locale("en", "US");
      }
    } else {
      temp = const Locale("en", "US");
    }
    MyApp.setLocale(context, temp);
    _commonProvider.loadLanguages();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: screenWidth / 1.5,
          child: Image.asset(
            'assets/logo_main.png',
          ),
        ),
      ),
    );
  }
}
