// // ignore_for_file: avoid_print, file_names

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mr_urban_customer_app/utils/color_widget.dart';
// import 'package:mr_urban_customer_app/utils/colors.dart';
// import 'package:mr_urban_customer_app/utils/text_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'ActivePage.dart';
// import 'CancelledPage.dart';
// import 'SuccessPage.dart';

// class BookingScreen extends StatefulWidget {
//   final String? type;
//   const BookingScreen({Key? key, this.type}) : super(key: key);

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen>
//     with SingleTickerProviderStateMixin {
//   TabController? _tabController;

//   @override
//   void initState() {
//     _tabController = TabController(length: 3, vsync: this);

//     super.initState();
//   }

//   late ColorNotifire notifire;
//   getdarkmodepreviousstate() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool? previusstate = prefs.getBool("setIsDark");
//     if (previusstate == null) {
//       notifire.setIsDark = false;
//     } else {
//       notifire.setIsDark = previusstate;
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController?.dispose();
//   }

//   var bookingpages = [
//     const ActiveScreen(),
//     const SuccessScreen(),
//     const CancelledScreen(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     notifire = Provider.of<ColorNotifire>(context, listen: true);
//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: notifire.getprimerycolor,
//           appBar: AppBar(
//             centerTitle: true,
//             elevation: 0,
//             leading: widget.type == "hide"
//                 ? InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child:
//                         Icon(Icons.arrow_back, color: notifire.getdarkscolor))
//                 : const SizedBox(),
//             backgroundColor: notifire.getprimerycolor,
//             title: Text("Booking",
//                 style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: notifire.getdarkscolor)),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Column(children: [
//               Container(
//                 height: 46,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: notifire.getprimerycolor,
//                     borderRadius: BorderRadius.circular(1.0)),
//                 child: TabBar(
//                     controller: _tabController,
//                     labelStyle: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontFamily: "Gilroy Bold",
//                         fontSize: 14),
//                     indicator: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: CustomColors.primaryColor),
//                     labelColor: Colors.white,
//                     unselectedLabelColor: notifire.getdarkscolor,
//                     tabs: const [
//                       Tab(text: TextString.pending),
//                       Tab(text: TextString.completed),
//                       Tab(text: TextString.cancelled),
//                     ]),
//               ),
//               Expanded(
//                 child: TabBarView(
//                     controller: _tabController, children: bookingpages),
//               ),
//             ]),
//           )),
//     );
//   }

//   Widget showDialogBox() {
//     return AlertDialog(
//       title: const Text("Please Login"),
//       actions: <Widget>[
//         TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel')),
//         TextButton(
//           onPressed: () {},
//           child: const Text('Login Page',
//               style: TextStyle(color: Colors.blueAccent)),
//         ),
//       ],
//     );
//   }
// }
