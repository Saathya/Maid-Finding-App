import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mr_urban_customer_app/IntroScreen/splash_screen.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ColorNotifire())],
    child: GetMaterialApp(
      title: 'Maid Finding App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Gilroy"),
      home: const Directionality(
          textDirection: TextDirection.ltr, // set this property
          child: SplashScreen()),
    ),
  ));
}
