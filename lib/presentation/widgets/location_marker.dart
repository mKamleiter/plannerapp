// In lib/presentation/helpers/location_marker.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mallorcaplanner/entities/category.dart';
import 'package:mallorcaplanner/entities/location.dart';

class LocationMarker {
  final Location location;
  final String? categoryImagePath;
  final bool isSelected;
  final Function onTap;
  final Set<Category>? selectedCategories;
  final bool isInTrip;

  LocationMarker({
    required this.location,
    this.categoryImagePath,
    this.isSelected = false,
    required this.onTap,
    this.selectedCategories,
    required this.isInTrip,
  });

  Marker build() {
    double markerSize = isSelected ? 30.0 : 30.0; // Sie können die Größe basierend auf dem isSelected-Status anpassen
    Color markerColor = isSelected ? Colors.blue : (isInTrip ? Colors.green : Colors.black87);
    print(selectedCategories);
    return Marker(
      width: markerSize,
      height: markerSize,
      point: location.coordinates,
      builder: (ctx) => GestureDetector(
        onTap: () => onTap(),
        child: categoryImagePath != null ? Image.asset(categoryImagePath!, color: markerColor) : Icon(Icons.error, color: markerColor),
      ),
    );
  }
}
