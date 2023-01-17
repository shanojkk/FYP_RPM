import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpm/const/color_const.dart';
import 'package:rpm/const/storage_keys.dart';
import 'package:rpm/main.dart';
import 'package:rpm/providers/common_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  SplashScreenState() {
    Timer(const Duration(milliseconds: 4800), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => AuthenticationWrapper(),
      //   ),
      // );
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
      backgroundColor: AppColors.bgBlue,
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Image.asset(
            'assets/images/logo/iconlogo.gif',
          ),
        ),
      ),
    );
  }
}
