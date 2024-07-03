// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/route_manager.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/ViewAllSection.dart';
import 'package:mr_urban_customer_app/BootomBar.dart';
import 'package:mr_urban_customer_app/loginAuth/change_password_screen.dart';
import 'package:mr_urban_customer_app/model/dummy/service.dart';
import 'package:mr_urban_customer_app/utils/color_widget.dart';
import 'package:mr_urban_customer_app/utils/colors.dart';
import 'package:mr_urban_customer_app/utils/image_icon_path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Servicedetail extends StatefulWidget {
  final Maid maid;

  const Servicedetail({Key? key, required this.maid}) : super(key: key);

  @override
  State<Servicedetail> createState() => _ServicedetailState();
}

class _ServicedetailState extends State<Servicedetail> {
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

  void addToCart(BuildContext context, Maid maid) async {
    // Check if the maid is already in the cart
    List<Maid> cartItems = await CartService.getCartItems();
    bool isAlreadyInCart =
        cartItems.any((item) => item.maidName == maid.maidName);

    if (isAlreadyInCart) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${maid.maidName} is already booked',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ));
    } else {
      await CartService.addToCart(maid);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${maid.maidName} is booked',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ));
    }
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

  late ColorNotifire notifire;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    double discountedPrice =
        widget.maid.maidPrice.minPrice * 0.8; // Applying 20% discount

    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: notifire
              .getdarkscolor, // Set icon color dynamically based on dark mode
        ),
        title: Text(
          "Book Your Service",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: notifire.getdarkscolor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.maid.maidImg),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.maid.maidName,
                    style:  TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:notifire.getdarkscolor
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        widget.maid.maidRating.minRating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        'Service Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: notifire.getdarkscolor
                        ),
                      ),
                      Text(
                        '₹${widget.maid.maidPrice.minPrice.toString()}',
                        // '₹${discountedPrice.toStringAsFixed(2)}', // Display discounted price
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  gridViewProduct(widget.maid.serviceItems),
                  const SizedBox(height: 24),
                  // const Text(
                  //   "Bestseller Maids",
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // listViewMaidData(),
                  // const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              addToCart(context, widget.maid);
              Get.to(() => const BottomNavigationBarScreen());
            },
            label: const Text(
              'Shortlist',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: const Icon(
              Icons.payment_rounded,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
          ),
          const SizedBox(width: 16), // Space between the buttons
          FloatingActionButton.extended(
            onPressed: () {
              _callNumber(widget.maid.number);
            },
            label: const Text(
              'Call Now',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: const Icon(
              Icons.call,
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget gridViewProduct(List<ServiceItem> services) {
    return GridView.builder(
      itemCount: services.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: Container(
            decoration: BoxDecoration(
              color: notifire.getdarkscolors,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  services[index].image,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  services[index].name,
                  textAlign: TextAlign.center,
                  style:  TextStyle(fontSize: 14,color: notifire.getdarkscolor,)
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget listViewMaidData() {
    // Assuming you have a list of bestseller packages excluding the current maid
    List<Maid> bestsellers = getBestsellersExcludingCurrent(widget.maid);

    return ListView.builder(
      itemCount: bestsellers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  bestsellers[index].maidImg,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bestsellers[index].maidName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 6,
                        children: widget.maid.serviceItems
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
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(ImagePath.starImg, scale: 30),
                            const SizedBox(width: 4),
                            Text(
                              '${bestsellers[index].maidRating.minRating.toString()} mins',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            addToCart(context, bestsellers[index]);
                            Get.to(() => const BottomNavigationBarScreen());
                          },
                          child: Container(
                            width: 55,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Changed background color to blue
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: const Center(
                              // Centered text
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold), // Modified text style
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Maid> getBestsellersExcludingCurrent(Maid currentMaid) {
    // Sample list of bestseller maids
    List<Maid> allBestsellers = [
      Maid(
        maidName: "Alice Smith",
        maidImg: "assets/img-3.jpg",
        maidPrice: PriceFilter(minPrice: 15000),
        maidLocation: LocationFilter(location: "New York"),
        maidEducation: EducationFilter(education: "High School"),
        maidRating: RatingFilter(minRating: 4.8),
        serviceItems: [
          ServiceItem(name: 'Cleaning', image: 'assets/cleaning.png'),
          ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
          ServiceItem(name: '12 hr', image: 'assets/12.png'),
        ],
        number: '+918287475473',
      ),
      Maid(
        maidName: "Emily Johnson",
        maidImg: "assets/img2.jpg",
        maidPrice: PriceFilter(minPrice: 10000),
        maidLocation: LocationFilter(location: "Los Angeles"),
        maidEducation: EducationFilter(education: "Bachelor's Degree"),
        maidRating: RatingFilter(minRating: 4.5),
        serviceItems: [
          ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
          ServiceItem(name: '12 hr', image: 'assets/12.png'),
          ServiceItem(name: 'Cleaning', image: 'assets/cleaning.png'),
        ],
        number: '+918178637168',
      ),
      Maid(
        maidName: "Sophia Williams",
        maidImg: "assets/home img-1.jpg",
        maidPrice: PriceFilter(minPrice: 18000),
        maidLocation: LocationFilter(location: "Chicago"),
        maidEducation: EducationFilter(education: "Associate's Degree"),
        maidRating: RatingFilter(minRating: 4.3),
        serviceItems: [
          ServiceItem(name: '12 hr', image: 'assets/12.png'),
          ServiceItem(name: 'Cleaning', image: 'assets/cleaning.png'),
          ServiceItem(name: 'Cooking', image: 'assets/cooking.png'),
        ],
        number: '+917982402366',
      ),
      // Add more Maid objects as needed
    ];

    // Exclude the current maid from the list
    return allBestsellers
        .where((maid) => maid.maidName != currentMaid.maidName)
        .toList();
  }
}
