// lib/domain/repositories/Trip_repository.dart

import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class TripRepository {
  Future<Trip> getTripById(String tripId);
  Future<Trip> getTripByCurrentUser();
  Future<void> editTrip(Trip trip);
  Future<void> deleteTrip(Trip trip);
  Future<void> addLocationToTrip(Location location, Trip trip);
  Future<void> removeLocationFromTrip(Location location, Trip trip);

}