import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Maid {
  String maidName;
  String maidImg;
  PriceFilter maidPrice;
  LocationFilter maidLocation;
  EducationFilter maidEducation;
  RatingFilter maidRating;
  List<ServiceItem> serviceItems;
  String paymentStatus; // Add this field

  Maid({
    required this.maidName,
    required this.maidImg,
    required this.maidPrice,
    required this.maidLocation,
    required this.maidEducation,
    required this.maidRating,
    required this.serviceItems,
    this.paymentStatus = 'pending', // Initialize with default value
  });

  // Convert to/from JSON if needed
  factory Maid.fromJson(Map<String, dynamic> json) {
    return Maid(
      maidName: json['maidName'],
      maidImg: json['maidImg'],
      maidPrice: PriceFilter.fromJson(json['maidPrice']),
      maidLocation: LocationFilter.fromJson(json['maidLocation']),
      maidEducation: EducationFilter.fromJson(json['maidEducation']),
      maidRating: RatingFilter.fromJson(json['maidRating']),
      serviceItems: (json['serviceItems'] as List)
          .map((item) => ServiceItem.fromJson(item))
          .toList(),
      paymentStatus: json['paymentStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maidName': maidName,
      'maidImg': maidImg,
      'maidPrice': maidPrice.toJson(),
      'maidLocation': maidLocation.toJson(),
      'maidEducation': maidEducation.toJson(),
      'maidRating': maidRating.toJson(),
      'serviceItems': serviceItems.map((item) => item.toJson()).toList(),
      'paymentStatus': paymentStatus,
    };
  }
}

class PriceFilter {
  final int minPrice;
  bool isSelected;

  PriceFilter({
    required this.minPrice,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'minPrice': minPrice,
      'isSelected': isSelected,
    };
  }

  factory PriceFilter.fromJson(Map<String, dynamic> json) {
    return PriceFilter(
      minPrice: json['minPrice'],
      isSelected: json['isSelected'],
    );
  }
}

class LocationFilter {
  String location;
  bool isSelected;

  LocationFilter({
    required this.location,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'isSelected': isSelected,
    };
  }

  factory LocationFilter.fromJson(Map<String, dynamic> json) {
    return LocationFilter(
      location: json['location'],
      isSelected: json['isSelected'],
    );
  }
}

class EducationFilter {
  String education;
  bool isSelected;

  EducationFilter({
    required this.education,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'education': education,
      'isSelected': isSelected,
    };
  }

  factory EducationFilter.fromJson(Map<String, dynamic> json) {
    return EducationFilter(
      education: json['education'],
      isSelected: json['isSelected'],
    );
  }
}

class RatingFilter {
  double minRating;
  bool isSelected;

  RatingFilter({
    required this.minRating,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'minRating': minRating,
      'isSelected': isSelected,
    };
  }

  factory RatingFilter.fromJson(Map<String, dynamic> json) {
    return RatingFilter(
      minRating: json['minRating'],
      isSelected: json['isSelected'],
    );
  }
}

class ServiceItem {
  final String name;
  final String image;

  ServiceItem({
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      name: json['name'],
      image: json['image'],
    );
  }
}

class CartService {
  static const String cartKey = 'cart_items';

  static Future<void> addToCart(Maid maid) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(cartKey) ?? [];
    cartItems.add(jsonEncode(maid.toJson()));
    await prefs.setStringList(cartKey, cartItems);
  }

  static Future<void> removeFromCart(Maid maid) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(cartKey) ?? [];

    // Filter out the maid object based on maidId
    cartItems.removeWhere((item) {
      Maid maidItem = Maid.fromJson(jsonDecode(item));
      return maidItem.maidName ==
          maid.maidName; // Assuming maidId is a unique identifier
    });

    await prefs.setStringList(cartKey, cartItems); // Save updated cart items
  }

  static Future<List<Maid>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(cartKey) ?? [];
    return cartItems.map((item) => Maid.fromJson(jsonDecode(item))).toList();
  }
}
