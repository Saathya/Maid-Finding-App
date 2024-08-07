// ignore_for_file: must_be_immutable, avoid_print, prefer_const_constructors, unused_catch_clause, prefer_is_empty, await_only_futures, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:mr_urban_customer_app/ApiServices/url.dart';
import 'package:mr_urban_customer_app/AppScreens/Filter/filterscreen.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/dummy/service_detail.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/home_screen.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/salon_at_home_for_woman_screen.dart';
// import 'package:mr_urban_customer_app/AppScreens/Home/salon_at_home_for_woman_screen.dart';
import 'package:mr_urban_customer_app/BootomBar.dart';
import 'package:mr_urban_customer_app/Controller/AppControllerApi.dart';
import 'package:mr_urban_customer_app/model/dummy/service.dart';
import 'package:mr_urban_customer_app/utils/AppWidget.dart';
import 'package:mr_urban_customer_app/utils/color_widget.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:mr_urban_customer_app/utils/image_icon_path.dart';
import 'package:mr_urban_customer_app/utils/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiServices/Api_werper.dart';
import '../../DataSqf/maineList.dart';

//! cat search
class SearchCategoryScreen extends StatefulWidget {
  final String? type;

  final String? catTital;
  final List? catList;
  final List<Maid>? filteredMaidList;

  String? catId;
  SearchCategoryScreen(
      {Key? key,
      this.catId,
      this.catTital,
      this.catList,
      this.type,
      this.filteredMaidList})
      : super(key: key);

  @override
  State<SearchCategoryScreen> createState() => _SearchCategoryScreenState();
}

class _SearchCategoryScreenState extends State<SearchCategoryScreen> {
  final x = Get.put(AppControllerApi());
  bool isSelected = true;
  bool isSelectedGrid = false;
  bool isVisibalVertical = true;
  bool isLoading = false;
  var userslength;
  final subWise = UserServiceData();

  final search = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    setState(() {});
    // widget.type == "Search" ? vendorSearchApi("a") : null;

    // insertData();
    // isLoading = true;

    // x.categoryWiseProviderApi(widget.catId).then((val) {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
    super.initState();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  Maid? maid;
  void addToCart(BuildContext context, Maid maid) async {
    // Check if the maid is already in the cart
    List<Maid> cartItems = await CartService.getCartItems();
    bool isAlreadyInCart =
        cartItems.any((item) => item.maidName == maid.maidName);

    if (isAlreadyInCart) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${maid.maidName} is already booked',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: notifire.getdarkscolor,
            fontSize: 16,
          ),
        ),
      ));
    } else {
      await CartService.addToCart(maid);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${maid.maidName} is booked',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: notifire.getdarkscolor,
            fontSize: 16,
          ),
        ),
      ));
    }
  }

  late ColorNotifire notifire;
  vendorSearchApi(String? val) {
    setState(() {});
    var data = {
      "keyword": val,
      "lats": lat,
      "longs": long,
      "cat_id": widget.catId ?? "0"
    };
    ApiWrapper.dataPost(Config.vendorsearch, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          vendorlist = val["VendorSearchData"];
          setState(() {});
        } else {
          vendorlist = [];
          setState(() {});
        }
      }
    });
  }

  insertData() {
    subWise.saveServiceData(
        serviceid: '',
        mtitle: '',
        quantity: '',
        img: '',
        video: '',
        servicetype: '',
        title: '',
        taketime: '',
        maxquantity: '',
        price: '',
        discount: '',
        servicedesc: '',
        status: '',
        isapprove: '');
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: notifire.getprimerycolor,
      body: isLoading == false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                statusBar(context),
                //! Search textField
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: notifire.getprimerycolor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            controller: search,
                            style: TextStyle(color: notifire.getdarkscolor),
                            onChanged: (val) {
                              if (val.length != 0) {
                                setState(() {
                                  searchText = val;
                                });
                              }
                              // if (val.length != 0) {
                              //   vendorSearchApi(val);
                              // } else {
                              //   x
                              //       .categoryWiseProviderApi(widget.catId)
                              //       .then((val) {
                              //     setState(() {
                              //       isLoading = false;
                              //     });
                              //   });
                              // }
                            },
                            cursorColor: notifire.getdarkscolor,
                            decoration: InputDecoration(
                              isDense: true,
                              hintStyle:
                                  TextStyle(color: notifire.getdarkscolor),
                              prefixIcon: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Icons.arrow_back,
                                    color: notifire.getdarkscolor),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/roundSearch.png",
                                  height: 24,
                                  width: 24,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.grey.shade300),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.grey.shade300),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              hintText: 'Search Maids',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Filterscreen()),
                            );
                          },
                          icon: Icon(
                            Icons.filter_list_rounded,
                            color: notifire.getdarkscolor,
                            size: 28,
                          ),
                          label: Text(
                            'Filter',
                            style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                // Add the rest of your UI components here

                SizedBox(height: Get.height * 0.02),
                !isLoading
                    ? vendorlist.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: notifire.getprimerycolor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: Get.width * 0.50,
                                            child: Text(
                                              widget.catTital ?? "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: notifire.getdarkscolor,
                                                  fontFamily:
                                                      CustomColors.fontFamily,
                                                  fontSize: 18),
                                            )),
                                        const Spacer(),
                                        //! ------- List view To GridView List -------
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isSelected = !isSelected;
                                                  isSelectedGrid = false;
                                                  isVisibalVertical = true;
                                                });
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        notifire.getdarkscolor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                          blurRadius: 6,
                                                          blurStyle:
                                                              BlurStyle.normal),
                                                    ]),
                                                child: isSelected
                                                    ? const Icon(Icons.menu,
                                                        color: CustomColors
                                                            .primaryColor)
                                                    : const Icon(Icons.menu,
                                                        color:
                                                            CustomColors.black),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isSelectedGrid =
                                                      !isSelectedGrid;
                                                  isSelected = false;
                                                  isVisibalVertical = false;
                                                });
                                              },
                                              child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 14),
                                                  decoration: BoxDecoration(
                                                      color: notifire
                                                          .getdarkscolor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.4),
                                                            blurRadius: 6,
                                                            blurStyle: BlurStyle
                                                                .normal),
                                                      ]),
                                                  child: isSelectedGrid
                                                      ? const Icon(
                                                          Icons
                                                              .grid_on_outlined,
                                                          color: CustomColors
                                                              .primaryColor)
                                                      : Icon(Icons
                                                          .grid_on_outlined)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    child: GetBuilder<AppControllerApi>(
                                        builder: (_) =>
                                            nearbyvendorsVerticalList()),
                                  )
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: widget.filteredMaidList == null ||
                                    widget.filteredMaidList!.isEmpty
                                ? maidList.length
                                : widget.filteredMaidList!.length,
                            itemBuilder: (context, index) {
                              Maid maid;
                              if (widget.filteredMaidList == null ||
                                  widget.filteredMaidList!.isEmpty) {
                                maid = maidList[index];
                              } else {
                                maid = widget.filteredMaidList![index];
                              }

                              // Check if maid name matches search text
                              bool matchesSearch = maid.maidName
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase());

                              // Render your maid item if it matches search text
                              if (!matchesSearch) {
                                return SizedBox
                                    .shrink(); // Skip rendering this maid
                              }

                              // Render your maid item here
                              return buildGridItem(maid, index);
                            },
                            // If no items match the search, show a message
                          )

                    // : Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 14, vertical: 5),
                    //     child: Column(children: [
                    //       SizedBox(height: Get.height * 0.10),
                    //       Image(
                    //           image: AssetImage("assets/emptyList1.png"),
                    //           height: Get.height * 0.28),
                    //       SizedBox(height: Get.height * 0.04),
                    //       Center(
                    //         child: SizedBox(
                    //           width: Get.width * 0.80,
                    //           child: const Text(
                    //               "Currently, Service not listed on this Category",
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                   color: Customnotifire.getdarkscolor,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontFamily: CustomColors.fontFamily,
                    //                   fontSize: 18)),
                    //         ),
                    //       ),
                    //     ]),
                    //   )
                    : Column(
                        children: [
                          SizedBox(height: Get.height * 0.34),
                          Center(
                            child: SizedBox(
                              child: isLoadingIndicator(),
                            ),
                          )
                        ],
                      ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                  backgroundColor: CustomColors.primaryColor)),
    );
  }

  Widget nearbyvendorsVerticalList() {
    return vendorlist.isEmpty
        ? GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 0.62,
            ),
            itemCount: widget.filteredMaidList == null ||
                    widget.filteredMaidList!.isEmpty
                ? maidList.length
                : widget.filteredMaidList!.length,
            itemBuilder: (context, index) {
              Maid maid;
              if (widget.filteredMaidList == null ||
                  widget.filteredMaidList!.isEmpty) {
                maid = maidList[index];
              } else {
                maid = widget.filteredMaidList![index];
              }
              return buildGridItem(maid, index);
            },
          )

        // ? Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        //     child: Column(children: [
        //       SizedBox(height: Get.height * 0.10),
        //       Image(
        //           image: AssetImage("assets/emptyList1.png"),
        //           height: Get.height * 0.28),
        //       SizedBox(height: Get.height * 0.04),
        //       Center(
        //         child: SizedBox(
        //           width: Get.width * 0.80,
        //           child: const Text(
        //               "Currently, Service not listed on this Category",
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                   color: Customnotifire.getdarkscolor,
        //                   fontWeight: FontWeight.bold,
        //                   fontFamily: CustomColors.fontFamily,
        //                   fontSize: 18)),
        //         ),
        //       ),
        //     ]),
        //   )
        : isVisibalVertical == true
            ? SizedBox(
                height: Get.height * 0.70,
                child: ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    shrinkWrap: true,
                    itemCount: vendorlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return userList(index);
                    }),
              )
            : SizedBox(
                height: Get.height * 0.70,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: vendorlist.length,
                  itemBuilder: (context, index) {
                    return userGridview(index);
                  },
                ));
  }

  List<Maid> maidList = [
    // New Delhi maids
    Maid(
      maidName: "Alice Smith",
      maidImg: "assets/home img-1.jpg",
      maidPrice: PriceFilter(minPrice: 15000),
      maidLocation: LocationFilter(location: "New Delhi"),
      maidEducation: EducationFilter(education: "High School"),
      maidRating: RatingFilter(minRating: 4.8),
      serviceItems: [
        ServiceItem(name: 'Cleaning', image: 'assets/cleaning.png'),
        ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
        ServiceItem(name: '12 hr', image: 'assets/12.png'),
      ],
      number: '7827783630',
    ),
    Maid(
      maidName: "John Doe",
      maidImg: "assets/img-3.jpg",
      maidPrice: PriceFilter(minPrice: 12000),
      maidLocation: LocationFilter(location: "New Delhi"),
      maidEducation: EducationFilter(education: "Bachelor's Degree"),
      maidRating: RatingFilter(minRating: 4.5),
      serviceItems: [
        ServiceItem(name: 'Cleaning', image: 'assets/cleaning.png'),
        ServiceItem(name: 'maid', image: 'assets/maid.png'),
        ServiceItem(name: '24 hr', image: 'assets/24-hours.png'),
      ],
      number: '7894561230',
    ),

    // Pune maids
    Maid(
      maidName: "Emily Johnson",
      maidImg: "assets/home img-1.jpg",
      maidPrice: PriceFilter(minPrice: 18000),
      maidLocation: LocationFilter(location: "Pune"),
      maidEducation: EducationFilter(education: "Associate's Degree"),
      maidRating: RatingFilter(minRating: 4.3),
      serviceItems: [
        ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
        ServiceItem(name: '24hr', image: 'assets/24-hours.png'),
        ServiceItem(name: 'maid', image: 'assets/maid.png'),
      ],
      number: '7982402366',
    ),
    Maid(
      maidName: "Sophia Williams",
      maidImg: "assets/img2.jpg",
      maidPrice: PriceFilter(minPrice: 16000),
      maidLocation: LocationFilter(location: "Pune"),
      maidEducation: EducationFilter(education: "High School"),
      maidRating: RatingFilter(minRating: 4.6),
      serviceItems: [
        ServiceItem(name: '12 hr', image: 'assets/12.png'),
        ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
        ServiceItem(name: 'childcare', image: 'assets/hands.png'),
      ],
      number: '7982402366',
    ),

    // Mumbai maids
    Maid(
      maidName: "Olivia Brown",
      maidImg: "assets/img2.jpg",
      maidPrice: PriceFilter(minPrice: 17000),
      maidLocation: LocationFilter(location: "Mumbai"),
      maidEducation: EducationFilter(education: "Master's Degree"),
      maidRating: RatingFilter(minRating: 4.9),
      serviceItems: [
        ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
        ServiceItem(name: 'Cleaning', image: 'assets/cleaning.png'),
        ServiceItem(name: '12 hr', image: 'assets/12.png'),
      ],
      number: '7890123456',
    ),
    Maid(
      maidName: "William Davis",
      maidImg: "assets/img-3.jpg",
      maidPrice: PriceFilter(minPrice: 15000),
      maidLocation: LocationFilter(location: "Mumbai"),
      maidEducation: EducationFilter(education: "Diploma"),
      maidRating: RatingFilter(minRating: 4.2),
      serviceItems: [
        ServiceItem(name: 'Cleaning', image: 'assets/cleaning.png'),
        ServiceItem(name: '24 hr', image: 'assets/24-hours.png'),
        ServiceItem(name: 'maid', image: 'assets/maid.png'),
      ],
      number: '7890123456',
    ),

    // Bengaluru maids
    Maid(
      maidName: "Emma Wilson",
      maidImg: "assets/home img-1.jpg",
      maidPrice: PriceFilter(minPrice: 14000),
      maidLocation: LocationFilter(location: "Bengaluru"),
      maidEducation: EducationFilter(education: "PhD"),
      maidRating: RatingFilter(minRating: 4.7),
      serviceItems: [
        ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
        ServiceItem(name: 'Cleaning', image: 'assets/cleaning.png'),
        ServiceItem(name: 'maid', image: 'assets/maid.png'),
      ],
      number: '7896541230',
    ),
    Maid(
      maidName: "James Miller",
      maidImg: "assets/img-3.jpg",
      maidPrice: PriceFilter(minPrice: 16000),
      maidLocation: LocationFilter(location: "Bengaluru"),
      maidEducation: EducationFilter(education: "Bachelor's Degree"),
      maidRating: RatingFilter(minRating: 4.4),
      serviceItems: [
        ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
        ServiceItem(name: 'childcare', image: 'assets/hands.png'),
        ServiceItem(name: '24 hr', image: 'assets/24-hours.png'),
      ],
      number: '7896541230',
    ),
  ];

  Widget buildGridItem(Maid maid, int index) {
    void callNumber(String number) async {
      try {
        bool? res = await FlutterPhoneDirectCaller.callNumber(number);
        print('Call initiated: $res');
        // Optionally handle the result here
      } catch (e) {
        print('Failed to make a phone call: $e');
        // Handle the exception as needed (e.g., show an error message)
      }
    }

    // Filter maids based on selected city
    if (maid.maidLocation.location != first) {
      return SizedBox
          .shrink(); // Return empty space if maid's city doesn't match selected city
    } else {
      // Render your data here when maid's city matches selected city
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: InkWell(
          onTap: () {
            Get.to(() => Servicedetail(maid: maid))!.then((value) {
              FocusScope.of(context).requestFocus(FocusNode());
            });
          },
          child: Card(
            color: notifire.getdarkscolors,
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
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: notifire.getdarkscolor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(ImagePath.starImg, scale: 30),
                                SizedBox(width: 4),
                                Text(
                                  maid.maidRating.minRating.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: notifire.getdarkscolor,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              children: maid.serviceItems
                                  .map((item) => Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                        addToCart(context, maid);
                        Get.to(() => const BottomNavigationBarScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Red background color
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Shortlist',
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
                        callNumber(maid.number);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Red background color
                      ),
                      child: Row(
                        children: const [
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
      ); // Replace with your actual widget or data rendering logic
    }
  }

  userList(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          setState(() {});
          // selectCartList.clear();
          Get.to(() => SalonAtHomeForWomanScreen(
                  title: widget.catTital,
                  storeName: vendorlist[index]["provider_title"],
                  vendorId: vendorlist[index]["provider_id"],
                  catId: widget.catId))!
              .then((value) {
            FocusScope.of(context).requestFocus(FocusNode());
          });
        },
        child: SizedBox(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                        imageUrl:
                            "${Config.imgBaseUrl}${vendorlist[index]["provider_img"]}",
                        fit: BoxFit.cover,
                        height: 160,
                        width: 150)),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Image.asset(ImagePath.starImg, scale: 22),
                      Text(vendorlist[index]["provider_rate"] ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: notifire.getdarkscolor)),
                    ],
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    width: Get.width * 0.3,
                    child: Text(vendorlist[index]["provider_title"] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: notifire.getdarkscolor,
                            fontFamily: CustomColors.fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                  const SizedBox(height: 8),
                  Text("Starts From",
                      style: TextStyle(
                          color: notifire.greyfont,
                          fontFamily: CustomColors.fontFamily,
                          fontSize: 14)),
                  const SizedBox(height: 12),
                  Container(
                    height: 28,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CustomColors.accentColor),
                    child: Center(
                      child: Text("$currency${vendorlist[index]["start_from"]}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]),
                const Spacer(),
                const Icon(Icons.more_horiz),
              ]),
        ),
      ),
    );
  }

  userGridview(index) {
    var users = x.categoryWiseModel?.providerData;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          setState(() {});
          // selectCartList.clear();
          Get.to(() => SalonAtHomeForWomanScreen(
                  title: widget.catTital,
                  storeName: users?[index].providerTitle,
                  vendorId: users?[index].providerId,
                  catId: widget.catId))!
              .then((value) {
            FocusScope.of(context).requestFocus(FocusNode());
          });
        },
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                    imageUrl:
                        "${Config.imgBaseUrl}${users?[index].providerImg}",
                    fit: BoxFit.cover,
                    height: 140,
                    width: 150),
              ),
              const SizedBox(height: 8),
              Text(users?[index].providerTitle ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
              const SizedBox(height: 3),
              const Text(TextString.startsFrom,
                  style: TextStyle(
                      fontFamily: CustomColors.fontFamily,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.grey,
                      fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColors.accentColor),
                    child: Center(
                      child: Text("$currency${users?[index].startFrom ?? ""}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(ImagePath.starImg, scale: 22),
                      Text(
                        users?[index].providerRate ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
