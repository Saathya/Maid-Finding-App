import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mr_urban_customer_app/AppScreens/Booking/Booking.dart';
import 'package:mr_urban_customer_app/BootomBar.dart';
import 'package:mr_urban_customer_app/model/dummy/service.dart'; // Replace with your service model

class Servicedetail extends StatefulWidget {
  final Maid maid;

  const Servicedetail({Key? key, required this.maid}) : super(key: key);

  @override
  State<Servicedetail> createState() => _ServicedetailState();
}

class _ServicedetailState extends State<Servicedetail> {
  void addToCart(BuildContext context) async {
    // Check if the maid is already in the cart
    List<Maid> cartItems = await CartService.getCartItems();
    bool isAlreadyInCart =
        cartItems.any((item) => item.maidName == widget.maid.maidName);

    if (isAlreadyInCart) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${widget.maid.maidName} is already booked',
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
        ),
      ));
    } else {
      await CartService.addToCart(widget.maid);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${widget.maid.maidName} is booked',
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double discountedPrice =
        widget.maid.maidPrice.minPrice * 0.8; // Applying 20% discount

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          " Book Your Service",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                      const Text(
                        'Service Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const Text(
                  //       'Original Price',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         color: Colors.grey,
                  //       ),
                  //     ),
                  //     Text(
                  //       '₹${widget.maid.maidPrice.minPrice.toString()}',
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         color: Colors.grey,
                  //         decoration: TextDecoration.lineThrough,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            gridViewProduct(widget.maid.serviceItems),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addToCart(context);

          Get.to(() => const BottomNavigationBarScreen());
        },
        label: const Text(
          'Book Now',
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
              color: Colors.white,
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
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
