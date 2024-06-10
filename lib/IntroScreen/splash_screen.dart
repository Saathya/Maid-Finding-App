import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mr_urban_customer_app/AppScreens/pagview_onbording_screen.dart';
import 'package:mr_urban_customer_app/BootomBar.dart';
import 'package:mr_urban_customer_app/loginAuth/login_screen.dart';
import 'package:mr_urban_customer_app/utils/color_widget.dart';
import 'package:mr_urban_customer_app/utils/image_icon_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiServices/Api_werper.dart';
import '../ApiServices/url.dart';

var countryCode = [];

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    cCodeApi();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    Timer(
      const Duration(seconds: 2),
      () async {
        final prefs = await SharedPreferences.getInstance();
        bool isFirstUser = prefs.getBool("Firstuser") ?? true;
        bool rememberUser = prefs.getBool("Remember") ?? false;

        if (user != null) {
          // User is signed in, navigate to BottomNavigationBarScreen
          Get.to(() => const BottomNavigationBarScreen());
        } else {
          // User is not signed in, navigate based on the shared preferences
          if (isFirstUser) {
            Get.to(() => const PagviewOnordingScreen());
          } else if (!rememberUser) {
            Get.to(() => const LoginScreen());
          } else {
            Get.to(() => const LoginScreen());
          }
        }
      },
    );
  }

  //! user CountryCode
  cCodeApi() {
    ApiWrapper.dataGet(Config.countryCodea).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          val["CountryCode"].forEach((e) {
            countryCode.add(e['ccode']);
          });
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Column(children: [
        SizedBox(height: Get.height * 0.36),
        Center(
          child: Image.asset(
            ImagePath.applogo,
            height: 150,
            width: 250,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          "Maid Finding App",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
              letterSpacing: 0.5),
        ),
      ]),
    );
  }
}
