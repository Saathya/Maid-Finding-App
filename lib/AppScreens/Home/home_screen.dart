// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, unused_catch_clause, avoid_print, unnecessary_string_escapes, depend_on_referenced_packages, prefer_is_empty, use_build_context_synchronously

import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/vendorCat.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../ApiServices/Api_werper.dart';
import '../../ApiServices/url.dart';
import '../../loginAuth/login_screen.dart';
import '../../model/home_page_model.dart';
import '../../utils/AppWidget.dart';
import '../../utils/color_widget.dart';
import '../../utils/image_icon_path.dart';
import '../../utils/text_widget.dart';
import '../Account/account_screen.dart';
import '../Notification/Notificationpage.dart';
import 'SeeAll.dart';
import 'ViewAllSection.dart';
import 'search_catogory_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

String uid = "0";
String? currency;
String? referCredit;
String? wallet;
var lat = 20.5937; // Default latitude for India
var long = 78.9629;
var first;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomePageModel? homePageModel;
  final List<HomePageModel> bannerList = [];
  bool isLoding = false;
  LatLng? _center;
  Position? currentLocation;
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;
  bool isChecked = false;
  String code = "0";
  int _currentIndex = 0;

  @override
  void initState() {
    walletrefar();
    // etdarkmodepreviousstate();
    initSharedPreferences();
    getPackage();
    setState(() {});
    getUserLocation1();
    getUid(); // Fetch user UID from Firebase Auth
    initOneSignal();
    // initPlatformState();
    // if (first == "Select City") {
    //   // Show city selection popup only if first is "Select City"
    //   showCitySelectionPopup();
    // }
    super.initState();
  }

  // lat == null ? getUserLocation() : getUserLocation1();

  late SharedPreferences prefs; // Declare SharedPreferences instance

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  etdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  List<String> dummyCityNames = [
    "Select City",
    "New Delhi",
    "Pune",
    "Bengaluru",
    "Mumbai"
  ];

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // Load previously selected city from SharedPreferences
    first = prefs.getString('selectedCity') ?? "Select City";
    setState(() {});
  }

  void saveSelectedCity(String selectedCity) {
    prefs.setString('selectedCity', selectedCity);
    first = selectedCity; // Update selected city
  }

  late ColorNotifire notifire;

  // Future getUserLocation() async {
  //   isLoding = true;
  //   setState(() {});

  // // Check and request location permissions if needed
  // LocationPermission permission;
  // permission = await Geolocator.checkPermission();
  // permission = await Geolocator.requestPermission();

  // // Obtain current location
  // var currentLocation = await locateUser();

  // // Retrieve latitude and longitude
  // lat = currentLocation.latitude;
  // long = currentLocation.longitude;

  // Retrieve city name using Geocoding
  // setState(() {
  //   // Update state variables
  //   // Assuming you want to display the first city name
  //   uid = getData.read("UserLogin") != null
  //       ? getData.read("UserLogin")["id"] ?? "0"
  //       : "0";
  //   homePageApi();

  // Show dropdown or popup menu with city names
  //   });
  // }

  // void showCitySelectionPopup() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Select City'),
  //         contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         content: SizedBox(
  //           width: double.maxFinite,
  //           child: DropdownButton<String>(
  //             isExpanded: true,
  //             underline: Container(
  //               height: 1,
  //               color: Colors.grey.shade400,
  //             ),
  //             icon: const Icon(Icons.arrow_drop_down),
  //             iconSize: 36,
  //             elevation: 8,
  //             style: const TextStyle(fontSize: 16, color: Colors.black),
  //             value: first, // Initially selected city
  //             onChanged: (String? selectedCity) {
  //               setState(() {
  //                 first = selectedCity!; // Update selected city
  //               });
  //               saveSelectedCity(first); // Save the current selected city
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             items:
  //                 dummyCityNames.map<DropdownMenuItem<String>>((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future getUserLocation1() async {
    isLoding = true;
    setState(() {});
    // LocationPermission permission;
    // permission = await Geolocator.checkPermission();
    // permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied) {}
    // var currentLocation = await locateUser();
    // debugPrint('location: ${currentLocation.latitude}');

    setState(() {
      homePageApi();
    });
  }

  Future<void> getUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userLoginData = preferences.getString("UserLogin");
    if (userLoginData != null) {
      var userData = jsonDecode(userLoginData);
      setState(() {
        uid = userData["user_id"] ??
            "0"; // Assuming "id" is where you store the user ID
      });
    }
  }

  Future<void> initOneSignal() async {
    await OneSignal.shared.setAppId(Config.oneSignel);
    await OneSignal.shared.promptUserForPushNotificationPermission();
    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("Accepted OSPermissionStateChanges : $changes");
    });

    // Set the user_id tag in OneSignal
    await OneSignal.shared.sendTag("user_id", uid);
    print("Set OneSignal user_id to: $uid");
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  final GlobalKey<ScaffoldState> _scaffoldKEy = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: notifire.detail,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // here the desired height
        child: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          backgroundColor: notifire.getprimerycolor,
          elevation: 0,
          title: InkWell(
            onTap: () async {
              // Prediction? p = await PlacesAutocomplete.show(
              //   context: context,
              //   apiKey: Config.googleKey,
              //   language: "en",
              //   decoration: const InputDecoration(
              //     hintText: "Search for your location/society/apt",
              //     focusedBorder: InputBorder.none,
              //   ),
              //   components: [],
              // );
              // displayPrediction(p, context).then((value) {
              //   homePageApi();
              // });

              // Show city selection popup only if first is "Select City"
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current City",
                  style: TextStyle(
                    fontFamily: CustomColors.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: notifire.getdarkscolor,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: notifire.getdarkscolor,
                        ),
                        iconSize: 36,
                        elevation: 8,
                        dropdownColor: notifire.getdarkscolors,
                        style: TextStyle(
                          fontSize: 16,
                          color: notifire.getdarkscolor,
                        ),
                        value: first, // Initially selected city
                        underline: Container(), // Remove the underline
                        onChanged: (String? city) {
                          if (city != null) {
                            saveSelectedCity(
                                city); // Save the current selected city
                          }
                        },
                        items: dummyCityNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: CustomColors.fontFamily,
                                fontWeight: FontWeight.w700,
                                color: notifire.getdarkscolor,
                                // Selected item color
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // const SizedBox(width: 8),
                    // Icon(Icons.arrow_drop_down, color: notifire.getdarkscolor),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => const Note());
              },
              child: CircleAvatar(
                  radius: 24,
                  backgroundColor: notifire.detail,
                  child: Image.asset("assets/Notification.png",
                      scale: 4, color: notifire.getdarkscolor)),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  User? user = FirebaseAuth.instance.currentUser;

                  setState(() {});
                  user != null
                      ? Get.to(() => const AccountScreen(type: "Home"))
                      : Get.to(() => const LoginScreen());
                },
                child: CircleAvatar(
                    radius: 24,
                    backgroundColor: notifire.detail,
                    child: Image.asset("assets/profileicon.png",
                        scale: 4, color: notifire.getdarkscolor)),
              ),
            ),
          ],
        ),
      ),
      body: isLoding == false
          ? SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    searchAcService(),
                    const SizedBox(height: 16),
                    listOfOffer(),
                    const SizedBox(height: 24),
                    serviceGridView(),
                    const SizedBox(height: 16),
                    homePageModel?.homeData?.providerData!.length != 0
                        ? nearbyVendorsList()
                        : const SizedBox(),
                    cleaningServicesList(),
                    const SizedBox(height: 16),
                    gift(),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text("Home Service, on demand",
                          style: TextStyle(
                              fontSize: 20,
                              color: notifire.getdarkscolor,
                              fontWeight: FontWeight.bold,
                              fontFamily: CustomColors.fontFamily)),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Image(
                              image: const AssetImage("assets/shieldcheck.png"),
                              color: notifire.getdarkscolor,
                              height: 20),
                          SizedBox(width: Get.width * 0.04),
                          Text(
                            "Our Experts give you 100% Satisfaction.",
                            style: TextStyle(
                                fontSize: 16,
                                color: notifire.getdarkscolor,
                                fontFamily: CustomColors.fontFamily),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Image(
                              image: const AssetImage("assets/starcircle.png"),
                              color: notifire.getdarkscolor,
                              height: 20),
                          SizedBox(width: Get.width * 0.04),
                          Text(
                            "On-time at your doorstep.",
                            style: TextStyle(
                                fontSize: 16,
                                color: notifire.getdarkscolor,
                                fontFamily: CustomColors.fontFamily),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Row(
                        children: [
                          Image(
                              image:
                                  const AssetImage("assets/receiptheart.png"),
                              color: notifire.getdarkscolor,
                              height: 20),
                          SizedBox(width: Get.width * 0.04),
                          Text(
                            "Ensure high-quality services.",
                            style: TextStyle(
                                fontSize: 16,
                                color: notifire.getdarkscolor,
                                fontFamily: CustomColors.fontFamily),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
            )
          : Center(
              heightFactor: Get.height / 50,
              child: const CircularProgressIndicator(
                backgroundColor: CustomColors.primaryColor,
              )),
    );
  }

  /// Search

  Widget searchAcService() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        width: double.infinity,
        decoration: BoxDecoration(
            color: notifire.getprimerycolor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getData.read("UserLogin") != null
                ? Text("HELLO ${getData.read("UserLogin")["name"] ?? ""} 👋 ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: CustomColors.fontFamily,
                        color: notifire.getdarkscolor))
                : const SizedBox(),
            const SizedBox(height: 8),
            Text(TextString.Whatyouarelookingfortoday,
                style: TextStyle(
                    fontSize: 20,
                    color: notifire.getdarkscolor,
                    fontWeight: FontWeight.w700,
                    fontFamily: CustomColors.fontFamily)),
            const SizedBox(height: 18),
            InkWell(
              onTap: () {
                Get.to(() => const SeeAllPage(
                      catTital: TextString.nearbyvendors,
                    ));
              },
              child: Container(
                width: Get.width,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.grey.shade400),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(width: Get.width * 0.02),
                      Image(
                          image: const AssetImage('assets/search.png'),
                          color: Colors.grey.shade400,
                          height: 22),
                      SizedBox(width: Get.width * 0.04),
                      Text(
                        "Search for",
                        style: TextStyle(
                            fontFamily: "Gilroy",
                            color: notifire.getdarkscolor,
                            fontWeight: FontWeight.w500),
                      ),
                      // SizedBox(width: Get.width * 0.01),
                      SizedBox(
                        width: Get.width * 0.50,
                        child: DefaultTextStyle(
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: notifire.getdarkscolor,
                                fontFamily: "Gilroy"),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                for (var i = 0;
                                    i <
                                        homePageModel!
                                            .homeData!.catlist!.length;
                                    i++)
                                  TypewriterAnimatedText(
                                      textStyle: TextStyle(
                                          color: notifire.getdarkscolor),
                                      " ${homePageModel!.homeData!.catlist![i].title.toString()}",
                                      speed: const Duration(milliseconds: 200)),
                              ],
                              onTap: () {},
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// List of offer
  Widget listOfOffer() {
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemCount: homePageModel?.homeData?.banner?.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return // items: bannerList
                ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: CachedNetworkImage(
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl:
                    "${Config.imgBaseUrl}${homePageModel?.homeData?.banner?[index].img}",
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: homePageModel?.homeData?.banner?.length ?? 0,
            effect: SlideEffect(
                dotColor: Colors.grey.shade400, dotHeight: 10, dotWidth: 10),
          ),
        ),
      ],
    );
  }

  /// Service of Grid
  Widget serviceGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: notifire.getprimerycolor,
              borderRadius: BorderRadius.circular(12)),
          child: Wrap(
            runSpacing: 20,
            alignment: WrapAlignment.spaceBetween,
            children: List<Widget>.generate(
              homePageModel?.homeData?.catlist?.length ?? 0,
              (int index) {
                return SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => SearchCategoryScreen(
                              catId:
                                  homePageModel?.homeData?.catlist?[index].id,
                              catTital:
                                  "${homePageModel?.homeData?.catlist?[index].title}"));
                        },
                        child: Container(
                          height: 65,
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: notifire.detail,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${Config.imgBaseUrl}${homePageModel?.homeData?.catlist?[index].catImg}",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${homePageModel?.homeData?.catlist?[index].title}",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: notifire.getdarkscolor,
                            fontFamily: CustomColors.fontFamily,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2),
                      ),
                    ],
                  ),
                );
              },
            ),
          )),
    );
  }

  /// Nearby Vendors List
  Widget nearbyVendorsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 310,
        width: double.infinity,
        decoration: BoxDecoration(
            color: notifire.getprimerycolor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(TextString.nearbyvendors,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: notifire.getdarkscolor,
                            fontFamily: CustomColors.fontFamily,
                            fontSize: 18)),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(() => const SeeAllPage(
                              catTital: TextString.nearbyvendors,
                            ));
                      },
                      child: Container(
                        height: 30,
                        // width: 92,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                            // border: Border.all(color: notifire.greyfont),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              TextString.seeAll,
                              style: TextStyle(
                                  color: notifire.getbluecolor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: CustomColors.fontFamily),
                            ),
                            // const Spacer(),
                            // Icon(Icons.arrow_forward_ios,
                            //     color: notifire.greyfont, size: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: homePageModel?.homeData?.providerData != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              homePageModel?.homeData?.providerData?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => VendorCatAllPage(
                                        title: homePageModel
                                            ?.homeData
                                            ?.providerData?[index]
                                            .providerTitle,
                                        pID: homePageModel?.homeData
                                            ?.providerData?[index].providerId));
                                  },
                                  child: SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            children: [
                                              CachedNetworkImage(
                                                  imageUrl:
                                                      "${Config.imgBaseUrl}${homePageModel?.homeData?.providerData?[index].providerImg}",
                                                  height: 160,
                                                  width: 160,
                                                  fit: BoxFit.cover),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "${homePageModel?.homeData?.providerData?[index].providerTitle}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: notifire.getdarkscolor,
                                              fontFamily:
                                                  CustomColors.fontFamily,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          TextString.startsFrom,
                                          style: TextStyle(
                                              fontFamily:
                                                  CustomColors.fontFamily,
                                              fontWeight: FontWeight.w500,
                                              color: notifire.greyfont,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(children: [
                                          Container(
                                            height: 30,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color:
                                                    CustomColors.accentColor),
                                            child: Center(
                                              child: Text(
                                                "$currency${homePageModel?.homeData?.providerData?[index].startFrom}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            height: 30,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.yellow.shade50),
                                            child: Center(
                                              child: Row(children: [
                                                Image.asset(ImagePath.starImg,
                                                    scale: 10),
                                                Text(
                                                  "${homePageModel?.homeData?.providerData?[index].providerRate}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ])
                                      ],
                                    ),
                                  )),
                            );
                          },
                        )
                      : const Center(child: Text("No data found")))
            ],
          ),
        ),
      ),
    );
  }

  Widget cleaningServicesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: homePageModel?.homeData!.sectionData!.length,
          itemBuilder: (BuildContext context, int i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                    color: notifire.getprimerycolor,
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              homePageModel!
                                      .homeData!.sectionData![i].sectionTitle ??
                                  "",
                              style: TextStyle(
                                  color: notifire.getdarkscolor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: CustomColors.fontFamily,
                                  fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ViewAllSectionPage(
                                      catID: homePageModel!
                                          .homeData!.sectionData![i].catId,
                                      sectionID: homePageModel!
                                          .homeData!.sectionData![i].sectionId,
                                      catTital: homePageModel!.homeData!
                                          .sectionData![i].sectionTitle,
                                    ));
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: Get.width * 0.06),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  TextString.seeAll,
                                  style: TextStyle(
                                      color: notifire.getbluecolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: CustomColors.fontFamily),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      height: 200,
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: homePageModel!
                              .homeData!.sectionData![i].itemList?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => SearchCategoryScreen(
                                          catId: homePageModel!
                                              .homeData!.sectionData![i].catId,
                                          catTital:
                                              "${homePageModel!.homeData!.sectionData![i].itemList?[index].itemTitle}"));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          CachedNetworkImage(
                                              imageUrl:
                                                  "${Config.imgBaseUrl}${homePageModel!.homeData!.sectionData![i].itemList?[index].itemImg}",
                                              fit: BoxFit.cover,
                                              height: 160,
                                              width: 150),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                      "${homePageModel!.homeData!.sectionData![i].itemList?[index].itemTitle}",
                                      style: TextStyle(
                                          fontFamily: CustomColors.fontFamily,
                                          fontWeight: FontWeight.w600,
                                          color: notifire.getdarkscolor,
                                          fontSize: 14)),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  /// Gift Card
  Widget gift() {
    return InkWell(
      onTap: () {
        share();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: notifire.getprimerycolor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(TextString.referService,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: notifire.getdarkscolor)),
              const SizedBox(height: 8),
              Row(children: [
                Text(TextString.inviteDet,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: notifire.getdarkscolor)),
                Text(
                  "\₹${homePageModel?.homeData?.referCredit}",
                  style: TextStyle(
                      color: notifire.getdarkscolor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ]),
            ]),
            const SizedBox(
                width: 120,
                height: 100,
                child: Image(
                  image: AssetImage("assets/refer.png"),
                )),
          ],
        ),
      ),
    );
  }

  //! Home Page Api

  homePageApi() {
    try {
      isLoding = true;
      var body = {"uid": uid, "lats": lat, "longs": long};

      ApiWrapper.dataPost(Config.homePage, body).then((val) {
        if ((val != null) && (val.isNotEmpty)) {
          if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
            setState(() {});
            homePageModel = HomePageModel.fromJson(val);
            currency = val["HomeData"]["currency"];
            referCredit = val["HomeData"]["Refer_Credit"];
            wallet = val["HomeData"]["wallet"].toString();
            isLoding = false;
            setState(() {});
            val["HomeData"]["SectionData"].forEach((e) {});
          } else {
            setState(() {});

            isLoding = false;
            ApiWrapper.showToastMessage(val["ResponseMsg"]);
          }
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: '$appName',
        text:
            'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code $code & Enjoy your shopping !!!',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: '$appName');
  }

  walletrefar() async {
    var data = {"uid": uid};
    ApiWrapper.dataPost(Config.referdata, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          code = val["code"];
        } else {
          setState(() {});
        }
      }
    });
  }
}
