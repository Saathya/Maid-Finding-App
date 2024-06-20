import 'package:flutter/material.dart';
import 'package:mr_urban_customer_app/AppScreens/Home/search_catogory_screen.dart';
import 'package:mr_urban_customer_app/model/dummy/service.dart';

class Filterscreen extends StatefulWidget {
  const Filterscreen({Key? key}) : super(key: key);

  @override
  State<Filterscreen> createState() => _FilterscreenState();
}

class _FilterscreenState extends State<Filterscreen> {
  List<PriceFilter> prices = [
    PriceFilter(minPrice: 10000),
    PriceFilter(minPrice: 15000),
    PriceFilter(minPrice: 20000),
  ];

  List<LocationFilter> dummyLocations = [
    LocationFilter(location: "New York"),
    LocationFilter(location: "Los Angeles"),
    LocationFilter(location: "Chicago"),
    LocationFilter(location: "Houston"),
  ];

  List<EducationFilter> dummyEducations = [
    EducationFilter(education: "High School"),
    EducationFilter(education: "Bachelor's Degree"),
    EducationFilter(education: "Associate's Degree"),
    EducationFilter(education: "Master's Degree"),
  ];

  List<RatingFilter> dummyRatings = [
    RatingFilter(minRating: 4.0),
    RatingFilter(minRating: 4.5),
    RatingFilter(minRating: 4.8),
    RatingFilter(minRating: 5.0),
  ];

  // Placeholder for maidList; replace with actual list of maids
  List<Maid> maidList = [
    Maid(
      maidName: "Alice Smith",
      maidImg: "assets/img-3.jpg",
      maidPrice: PriceFilter(minPrice: 15000),
      maidLocation: LocationFilter(location: "New York"),
      maidEducation: EducationFilter(education: "High School"),
      maidRating: RatingFilter(minRating: 4.8),
      serviceItems: [
        ServiceItem(name: 'Cleaning', image: 'assets/cleaning.jpg'),
      ],
    ),
    Maid(
      maidName: "Emily Johnson",
      maidImg: "assets/img2.jpg",
      maidPrice: PriceFilter(minPrice: 10000),
      maidLocation: LocationFilter(location: "Los Angeles"),
      maidEducation: EducationFilter(education: "Bachelor's Degree"),
      maidRating: RatingFilter(minRating: 4.5),
      serviceItems: [
        ServiceItem(name: 'Cooking', image: 'assets/cooking.jpg'),
      ],
    ),
    Maid(
      maidName: "Sophia Williams",
      maidImg: "assets/home img-1.jpg",
      maidPrice: PriceFilter(minPrice: 18000),
      maidLocation: LocationFilter(location: "Chicago"),
      maidEducation: EducationFilter(education: "Associate's Degree"),
      maidRating: RatingFilter(minRating: 4.3),
      serviceItems: [
        ServiceItem(name: 'Child Care', image: 'assets/childcare.jpg'),
      ],
    ),
    // Add more Maid objects as needed
  ];

  void resetFilters() {
    setState(() {
      // Reset selected indices for prices
      for (var price in prices) {
        price.isSelected = false;
      }

      // Reset isSelected for locations
      for (var location in dummyLocations) {
        location.isSelected = false;
      }

      // Reset isSelected for educations
      for (var education in dummyEducations) {
        education.isSelected = false;
      }

      // Reset isSelected for ratings
      for (var rating in dummyRatings) {
        rating.isSelected = false;
      }
    });
  }

  void applyFilters() {
    // Filter your maidList based on selected filters
    List<Maid> filteredMaidList = maidList.where((maid) {
      // Check if maid meets all selected filter criteria
      bool meetsCriteria = prices.any((price) =>
              price.isSelected && maid.maidPrice.minPrice >= price.minPrice) ||
          dummyLocations.any((location) =>
              location.isSelected &&
              maid.maidLocation.location == location.location) ||
          dummyEducations.any((education) =>
              education.isSelected &&
              maid.maidEducation.education == education.education) ||
          dummyRatings.any((rating) =>
              rating.isSelected &&
              maid.maidRating.minRating >= rating.minRating);

      if (meetsCriteria) {
        print("Maid ${maid.maidName} does meet filter criteria:");
        if (!prices.any((price) =>
            price.isSelected && maid.maidPrice.minPrice >= price.minPrice)) {
          print(" - Price: ${maid.maidPrice.minPrice}");
        }
        if (!dummyLocations.any((location) =>
            location.isSelected &&
            maid.maidLocation.location == location.location)) {
          print(" - Location: ${maid.maidLocation.location}");
        }
        if (!dummyEducations.any((education) =>
            education.isSelected &&
            maid.maidEducation.education == education.education)) {
          print(" - Education: ${maid.maidEducation.education}");
        }
        if (!dummyRatings.any((rating) =>
            rating.isSelected &&
            maid.maidRating.minRating >= rating.minRating)) {
          print(" - Rating: ${maid.maidRating.minRating}");
        }
      }

      return meetsCriteria;
    }).toList();

    // Navigate to SearchCategoryScreen with filteredMaidList
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchCategoryScreen(filteredMaidList: filteredMaidList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Filter",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        iconTheme: Theme.of(context).primaryIconTheme,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetFilters,
          ),
          ElevatedButton(
            onPressed: applyFilters,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green, // text color
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSectionTitle("Price"),
              const SizedBox(height: 10),
              CustomPriceFilter(prices: prices),
              const SizedBox(height: 20),
              buildSectionTitle("Education"),
              const SizedBox(height: 10),
              CustomEducationFilter(educations: dummyEducations),
              const SizedBox(height: 20),
              buildSectionTitle("Location"),
              const SizedBox(height: 10),
              CustomLocationFilter(locations: dummyLocations),
              const SizedBox(height: 20),
              buildSectionTitle("Rating"),
              const SizedBox(height: 10),
              CustomRatingFilter(ratings: dummyRatings),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class CustomPriceFilter extends StatefulWidget {
  final List<PriceFilter> prices;

  const CustomPriceFilter({Key? key, required this.prices}) : super(key: key);

  @override
  _CustomPriceFilterState createState() => _CustomPriceFilterState();
}

class _CustomPriceFilterState extends State<CustomPriceFilter> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.prices
            .map((price) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: PriceItem(price: price),
                ))
            .toList(),
      ),
    );
  }
}

class PriceItem extends StatefulWidget {
  final PriceFilter price;

  const PriceItem({Key? key, required this.price}) : super(key: key);

  @override
  _PriceItemState createState() => _PriceItemState();
}

class _PriceItemState extends State<PriceItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.price.isSelected = !widget.price.isSelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
          color: widget.price.isSelected ? Colors.red : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          "₹${widget.price.minPrice}",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class CustomLocationFilter extends StatefulWidget {
  final List<LocationFilter> locations;

  const CustomLocationFilter({Key? key, required this.locations})
      : super(key: key);

  @override
  _CustomLocationFilterState createState() => _CustomLocationFilterState();
}

class _CustomLocationFilterState extends State<CustomLocationFilter> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.locations
            .map((location) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LocationItem(location: location),
                ))
            .toList(),
      ),
    );
  }
}

class LocationItem extends StatefulWidget {
  final LocationFilter location;

  const LocationItem({Key? key, required this.location}) : super(key: key);

  @override
  _LocationItemState createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.location.isSelected = !widget.location.isSelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: widget.location.isSelected ? Colors.red : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          widget.location.location,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: widget.location.isSelected ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class CustomEducationFilter extends StatefulWidget {
  final List<EducationFilter> educations;

  const CustomEducationFilter({Key? key, required this.educations})
      : super(key: key);

  @override
  _CustomEducationFilterState createState() => _CustomEducationFilterState();
}

class _CustomEducationFilterState extends State<CustomEducationFilter> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.educations.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              widget.educations[index].isSelected =
                  !widget.educations[index].isSelected;
            });
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.educations[index].education,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(
                  height: 25,
                  child: Checkbox(
                    value: widget.educations[index].isSelected,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        setState(() {
                          widget.educations[index].isSelected = newValue;
                        });
                      }
                    },
                    activeColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomRatingFilter extends StatefulWidget {
  final List<RatingFilter> ratings;

  const CustomRatingFilter({Key? key, required this.ratings}) : super(key: key);

  @override
  _CustomRatingFilterState createState() => _CustomRatingFilterState();
}

class _CustomRatingFilterState extends State<CustomRatingFilter> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.ratings.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              widget.ratings[index].isSelected =
                  !widget.ratings[index].isSelected;
            });
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.ratings[index].minRating.toString(),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(
                  height: 25,
                  child: Checkbox(
                    value: widget.ratings[index].isSelected,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        setState(() {
                          widget.ratings[index].isSelected = newValue;
                        });
                      }
                    },
                    activeColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
