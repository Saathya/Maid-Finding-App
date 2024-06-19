// import 'package:flutter/material.dart';
// import 'package:mr_urban_customer_app/model/dummy/service.dart'; // Import your filter models

// class FilterState extends ChangeNotifier {
//   // Lists for filtering
//   List<PriceFilter> prices = [
//     PriceFilter(minPrice: 10000),
//     PriceFilter(minPrice: 15000),
//     PriceFilter(minPrice: 20000),
//   ];

//   List<LocationFilter> dummyLocations = [
//     LocationFilter(location: "New York"),
//     LocationFilter(location: "Los Angeles"),
//     LocationFilter(location: "Chicago"),
//     LocationFilter(location: "Houston"),
//   ];

//   List<EducationFilter> dummyEducations = [
//     EducationFilter(education: "High School"),
//     EducationFilter(education: "Bachelor's Degree"),
//     EducationFilter(education: "Associate's Degree"),
//     EducationFilter(education: "Master's Degree"),
//   ];

//   List<RatingFilter> dummyRatings = [
//     RatingFilter(minRating: 4.0),
//     RatingFilter(minRating: 4.5),
//     RatingFilter(minRating: 4.8),
//     RatingFilter(minRating: 5.0),
//   ];

//   // Original maidList (or fetch from a service)
//   List<Maid> maidList = [
//     Maid(
//       maidName: "Alice Smith",
//       maidImg: "assets/img-3.jpg",
//       maidPrice: PriceFilter(minPrice: 15000),
//       maidLocation: LocationFilter(location: "New York"),
//       maidEducation: EducationFilter(education: "High School"),
//       maidRating: RatingFilter(minRating: 4.8),
//     ),
//     Maid(
//       maidName: "Emily Johnson",
//       maidImg: "assets/img2.jpg",
//       maidPrice: PriceFilter(minPrice: 10000),
//       maidLocation: LocationFilter(location: "Los Angeles"),
//       maidEducation: EducationFilter(education: "Bachelor's Degree"),
//       maidRating: RatingFilter(minRating: 4.5),
//     ),
//     Maid(
//       maidName: "Sophia Williams",
//       maidImg: "assets/home img-1.jpg",
//       maidPrice: PriceFilter(minPrice: 18000),
//       maidLocation: LocationFilter(location: "Chicago"),
//       maidEducation: EducationFilter(education: "Associate's Degree"),
//       maidRating: RatingFilter(minRating: 4.3),
//     ),
//     // Add more Maid objects as needed
//   ];

//   // Track filtered results
//   List<Maid> _filteredMaidList = [];

//   List<Maid> get filteredMaidList => _filteredMaidList;

//   // Apply filters based on selected criteria
//   void applyFilters() {
//     _filteredMaidList = maidList.where((maid) {
//       bool meetsCriteria = prices.any((price) =>
//               price.isSelected && maid.maidPrice.minPrice >= price.minPrice) &&
//           dummyLocations.any((location) =>
//               location.isSelected &&
//               maid.maidLocation.location == location.location) &&
//           dummyEducations.any((education) =>
//               education.isSelected &&
//               maid.maidEducation.education == education.education) &&
//           dummyRatings.any((rating) =>
//               rating.isSelected &&
//               maid.maidRating.minRating >= rating.minRating);

//       return meetsCriteria;
//     }).toList();

//     notifyListeners();
//   }

//   // Reset all filters and clear filtered results
//   void clearFilterState() {
//     resetFilters();
//     _filteredMaidList.clear();
//     notifyListeners();
//   }

//   // Reset all filter selections
//   void resetFilters() {
//     for (var price in prices) {
//       price.isSelected = false;
//     }
//     for (var location in dummyLocations) {
//       location.isSelected = false;
//     }
//     for (var education in dummyEducations) {
//       education.isSelected = false;
//     }
//     for (var rating in dummyRatings) {
//       rating.isSelected = false;
//     }
//     notifyListeners();
//   }

//   // Toggle selection for PriceFilter
//   void togglePriceSelection(PriceFilter selectedPrice) {
//     selectedPrice.isSelected = !selectedPrice.isSelected;
//     notifyListeners();
//   }

//   void toggleLocationSelection(LocationFilter selectedLocation) {
//     selectedLocation.isSelected = !selectedLocation.isSelected;
//     notifyListeners();
//   }

//   // Toggle selection for EducationFilter
//   void toggleEducationSelection(EducationFilter selectedEducation) {
//     selectedEducation.isSelected = !selectedEducation.isSelected;
//     notifyListeners();
//   }

//   // Toggle selection for RatingFilter
//   void toggleRatingSelection(RatingFilter selectedRating) {
//     selectedRating.isSelected = !selectedRating.isSelected;
//     notifyListeners();
//   }
// }
