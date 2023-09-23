// lib/domain/repositories/hotel_repository.dart

import 'package:mallorcaplanner/entities/hotel.dart';

abstract class HotelRepository {
  Future<Hotel> getHotelByTrip(String tripId);
  // Weitere Methoden, die Sie benötigen...
}