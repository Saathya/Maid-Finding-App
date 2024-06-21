// ignore_for_file: unused_import, file_names, depend_on_referenced_packages, no_duplicate_case_values, use_super_parameters, use_build_context_synchronously, unreachable_switch_case

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mr_urban_customer_app/ApiServices/url.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/home_screen.dart';
import 'package:mr_urban_customer_app/model/dummy/service.dart';
import 'package:mr_urban_customer_app/utils/color_widget.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:mr_urban_customer_app/utils/image_icon_path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ApiServices/Api_werper.dart';
import '../../utils/AppWidget.dart';
import 'BookingDetails.dart';
import 'CancelledPage.dart';
import 'oldCancel.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({Key? key}) : super(key: key);

  @override
  State<ActiveScreen> createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  String? oStatus = '';
  Color? buttonColor;
  @override
  void initState() {
    fetchMaidData(); // Fetch maid data on screen initialization

    super.initState();
  }

  List<Maid> maidData = []; // List to store maid data

  void fetchMaidData() async {
    List<Maid> cartItems = await CartService.getCartItems();

    // Filter maid data based on payment status (e.g., "pending")
    List<Maid> pendingMaidData = cartItems.where((maid) {
      return maid.paymentStatus == 'pending';
    }).toList();

    setState(() {
      maidData = pendingMaidData; // Update state with filtered data
    });
  }

  void removeFromCart(Maid maid) async {
    await CartService.removeFromCart(maid);
    fetchMaidData(); // Refresh the maid data after removing the item
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '${maid.maidName} removed from booking',
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
      ),
    ));
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

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      body: FutureBuilder(
        future: bookingActiveApi(),
        builder: (context, AsyncSnapshot snap) {
          if (snap.hasData) {
            var users = snap.data;
            return users.length != 0
                ? ListView.builder(
                    itemCount: users.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      return activeList(users[i]);
                    },
                  )
                : maidDataListView();
          } else {
            return Center(child: isLoadingIndicator());
          }
        },
      ),
    );
  }

  Widget maidDataListView() {
    return maidData.isNotEmpty
        ? ListView.builder(
            itemCount: maidData.length,
            shrinkWrap: true,
            itemBuilder: (ctx, i) {
              return buildGridItem(maidData[i], i);
            },
          )
        : emptyBooking();
  }

  Widget buildGridItem(Maid maid, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: SizedBox(
        width: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                maid.maidImg,
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              ),
            ),
            const SizedBox(
                width: 10), // Add some space between image and content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.starImg, scale: 30),
                        const SizedBox(
                            width:
                                4), // Adjust spacing between star and rating text
                        Text(
                          maid.maidRating.minRating.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 69.0),
                      child: Container(
                        height: 25,
                        width: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(
                            '₹${maid.maidPrice.minPrice.toString()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: CustomColors.fontFamily),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  maid.maidName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: CustomColors.fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Wrap(
                      spacing: 6,
                      children: maid.serviceItems
                          .map((item) => Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: CustomColors.accentColor,
                                ),
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .take(2)
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                          color: CustomColors.orangeColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          maid.paymentStatus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: CustomColors.fontFamily),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 42.0),
                      child: InkWell(
                        onTap: () {
                          removeFromCart(maid); // Call remove function here
                        },
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                              color: CustomColors.red,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Center(
                            child: Text(
                              'Remove',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: CustomColors.fontFamily),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  activeList(users) {
    switch (users["status"]) {
      case "Accepted":
        oStatus = users["status"];
        buttonColor = CustomColors.gradientColor;
        break;
      case "Pending":
        oStatus = users["status"];
        buttonColor = CustomColors.orangeColor;
        break;
      case "Ongoing":
        oStatus = users["status"];
        buttonColor = CustomColors.lightyello;
        break;
      case "Pickup Order":
        oStatus = users["status"];
        buttonColor = CustomColors.gradientColor;
        break;
      case "Pickup Order":
        oStatus = users["status"];
        buttonColor = CustomColors.RedColor;
        break;
      case "Job_start":
        oStatus = users["status"];
        buttonColor = CustomColors.gradientColor;
        break;
      case "Processing":
        oStatus = users["status"];
        buttonColor = CustomColors.gradientColor;
        break;
      default:
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: InkWell(
        onTap: () {
          Get.to(() => OrderDetailsPage(orderID: users["id"]));
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: notifire.detail,
              ),
              borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${users["id"]}",
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: CustomColors.fontFamily),
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        users["status"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: CustomColors.fontFamily),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "Service Date",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: notifire.getdarkscolor,
                    fontFamily: CustomColors.fontFamily,
                    fontSize: 16),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${users["service_date"] + "-" + users["service_time"]}",
                    style: TextStyle(
                        color: notifire.greyfont,
                        fontFamily: CustomColors.fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "$currency${users["total"]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: notifire.getdarkscolor,
                        fontFamily: CustomColors.fontFamily,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
                const Icon(
                  Icons.location_on_sharp,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: Get.width * 0.80,
                  child: Text(
                    "${users["customer_address"]}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: notifire.getdarkscolor,
                        fontFamily: CustomColors.fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
            SizedBox(height: Get.height * 0.01)
          ]),
        ),
      ),
    );
  }

  Future bookingActiveApi() async {
    var data = {"uid": uid, "type": "active"};
    try {
      var url = Uri.parse(Config.baseUrl + Config.orderhistory);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        setState(() {});
        return response["OrderHistory"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }
}
