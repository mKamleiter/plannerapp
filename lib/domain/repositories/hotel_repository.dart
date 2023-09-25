// lib/domain/repositories/hotel_repository.dart

import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class HotelRepository {
  Future<Hotel> getHotelByTrip(Trip trip);
  Future<Hotel> getHotelByName(String name);
  Future<List<Hotel>> getHotelSuggestions(String query);
  // Weitere Methoden, die Sie benötigen...
}