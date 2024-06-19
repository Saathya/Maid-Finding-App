// ignore_for_file: file_names, prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mr_urban_customer_app/AppScreens/Account/account_screen.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/home_screen.dart';
import 'package:mr_urban_customer_app/loginAuth/login_screen.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:mr_urban_customer_app/utils/image_icon_path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppScreens/Booking/Booking.dart';
// import 'AppScreens/Wallet/WalletHistory.dart';
import 'utils/AppWidget.dart';

var isLoagin;
int selectedIndex = 0;

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    setState(() {});
    isLoagin = getData.read("UserLogin");

    tabController = TabController(length: 3, vsync: this);
  }

  late ColorNotifire notifire;
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  List<Widget> myChilders = [
    const HomeScreen(),
    const BookingScreen(),
    // const WalletReportPage(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: myChilders),
        bottomNavigationBar: BottomAppBar(
          color: notifire.getprimerycolor,
          child: TabBar(
            onTap: (index) {
              User? user = FirebaseAuth.instance.currentUser;

              setState(() {});

              if (user != null) {
                selectedIndex = index;
              } else {
                index != 0
                    ? Get.to(() => const LoginScreen())
                    : const SizedBox();
              }
            },
            indicator: const UnderlineTabIndicator(
              insets: EdgeInsets.only(bottom: 6),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            // labelColor: Colors.white,
            // indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: notifire.greyfont,
            controller: tabController,
            tabs: [
              Tab(
                  child: Column(children: [
                Image.asset(
                  ImagePath.homeImg,
                  scale: 19,
                  color: Colors.white,
                ),
                const Text('Home',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ])),
              Tab(
                  child: Column(children: [
                Image.asset(
                  ImagePath.bookingImg,
                  scale: 19,
                  color: Colors.white,
                ),
                const Text('Booking',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ])),
              // Tab(
              //     child: Column(children: [
              //   Image.asset(
              //     ImagePath.walletIcon,
              //     scale: 19,
              //     color: Colors.white,
              //   ),
              //   const Text('Wallet',
              //       style: TextStyle(fontSize: 12, color: Colors.white)),
              // ])),
              Tab(
                  child: Column(children: [
                Image.asset(
                  ImagePath.userIcon,
                  scale: 19,
                  color: Colors.white,
                ),
                const Text('Account',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ])),
            ],
          ),
        ),
      ),
    );
  }
}
