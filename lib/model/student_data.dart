import 'dart:io';

class StudentData {
  final String id;
  final String name;
  final String categoryName;
  PlaceLocation? location;
  final File image;

  StudentData({
    required this.id,
    required this.categoryName,
    required this.image,
    required this.name,
    this.location,
  });

  toList() {}
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address;

  const PlaceLocation({
     this.address,
    required this.latitude,
    required this.longitude,
  });
}

class Category {
  final String id;
  final String imagename;
  final String name;

  const Category({
    required this.imagename,
    required this.id,
    required this.name,
  });
}


