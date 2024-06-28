// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:mr_urban_customer_app/ApiServices/Api_werper.dart';
import 'package:mr_urban_customer_app/AppScreens/Booking/BookingDetails.dart';
import 'package:mr_urban_customer_app/model/dummy/service.dart';
import 'package:mr_urban_customer_app/utils/AppWidget.dart';
import 'package:mr_urban_customer_app/utils/color_widget.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mr_urban_customer_app/ApiServices/url.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/home_screen.dart';
import 'package:mr_urban_customer_app/utils/image_icon_path.dart';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  final String? type;
  const BookingScreen({Key? key, this.type}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
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

  void _callNumber(String number) async {
    try {
      bool? res = await FlutterPhoneDirectCaller.callNumber(number);
      print('Call initiated: $res');
      // Optionally handle the result here
    } catch (e) {
      print('Failed to make a phone call: $e');
      // Handle the exception as needed (e.g., show an error message)
    }
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
    return SafeArea(
        child: Scaffold(
            backgroundColor: notifire.getprimerycolor,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              leading: widget.type == "hide"
                  ? InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child:
                          Icon(Icons.arrow_back, color: notifire.getdarkscolor))
                  : const SizedBox(),
              backgroundColor: notifire.getprimerycolor,
              title: Text("Shortlist",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: notifire.getdarkscolor)),
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: notifire.getprimerycolor,
                        borderRadius: BorderRadius.circular(1.0)),
                    child: FutureBuilder(
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
                  )
                ]))));
  }

  Widget maidDataListView() {
    if (maidData.isNotEmpty) {
      return Column(
        children: [
          ListView.builder(
            itemCount: maidData.length,
            shrinkWrap: true,
            itemBuilder: (ctx, i) {
              return buildGridItem1(maidData[i], i);
            },
          ),
        ],
      );
    } else {
      return Center(
        child: emptyBooking(),
      );
    }
  }

  Widget buildGridItem1(Maid maid, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {},
        child: Card(
          color: Colors.transparent,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 120, // Increased width
                        height: 100, // Increased height
                        child: Image.asset(
                          maid.maidImg,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maid.maidPrice.minPrice.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 1,
                              color: Colors.transparent,
                            ),
                          ),
                          Text(
                            maid.maidName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "₹${maid.maidPrice.minPrice.toString()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(ImagePath.starImg, scale: 30),
                              const SizedBox(width: 4),
                              Text(
                                maid.maidRating.minRating.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ))
                                .take(2)
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      removeFromCart(maid); // Call remove function here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Red background color
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.remove_circle,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Remove',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _callNumber(maid.number);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red background color
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.call,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Call Maid',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridItem(Maid maid, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
      child: SizedBox(
        width: 220,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                maid.maidImg,
                fit: BoxFit.cover,
                height: 125,
                width: 115,
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
                      padding: const EdgeInsets.only(left: 85.0),
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
                Row(
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          _callNumber(maid.number);
                        },
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius:
                                  12, // Adjust the radius to your preference
                              backgroundColor: Colors
                                  .white, // Change the background color if needed
                              child: Icon(
                                Icons.call,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Call Now',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12), // Adjusted padding
                      decoration: BoxDecoration(
                        color: CustomColors.orangeColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          maid.paymentStatus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: CustomColors.fontFamily,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        removeFromCart(maid); // Call remove function here
                      },
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12), // Adjusted padding
                        decoration: BoxDecoration(
                          color: CustomColors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            'Remove',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: CustomColors.fontFamily,
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

  Widget showDialogBox() {
    return AlertDialog(
      title: const Text("Please Login"),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        TextButton(
          onPressed: () {},
          child: const Text('Login Page',
              style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
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
