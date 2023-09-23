
import 'package:mallorcaplanner/entities/location.dart';

abstract class LocationRepository {
  Future<List<Location>> getAllLocations();
  Future<List<Location>> getLocationsByCategory(String category);
  Future<List<Location>> getLocationsByTrip(String tripId);
  // Weitere Methoden, die Sie benötigen...
}