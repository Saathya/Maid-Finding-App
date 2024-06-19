class Maid {
  String maidName;
  String maidImg;
  PriceFilter maidPrice;
  LocationFilter maidLocation;
  EducationFilter maidEducation;
  RatingFilter maidRating;

  Maid({
    required this.maidName,
    required this.maidImg,
    required this.maidPrice,
    required this.maidLocation,
    required this.maidEducation,
    required this.maidRating,
  });
}

class PriceFilter {
  final int minPrice;
  bool isSelected; // New property to track selection

  PriceFilter({
    required this.minPrice,
    this.isSelected = false, // Default value for isSelected
  });
}

class LocationFilter {
  String location;
  bool isSelected; // Track selection state

  LocationFilter({required this.location, this.isSelected = false});
}

class EducationFilter {
  String education;
  bool isSelected; // Track selection state

  EducationFilter({required this.education, this.isSelected = false});
}

class RatingFilter {
  double minRating;
  bool isSelected; // Track selection state

  RatingFilter({required this.minRating, this.isSelected = false});
}
