// lib/domain/repositories/Trip_repository.dart

import 'package:mallorcaplanner/entities/trip.dart';

abstract class TripRepository {
  Future<Trip> getTripById(String tripId);
  Future<Trip> getTripByCurrentUser();
  // Weitere Methoden, die Sie benötigen...
}