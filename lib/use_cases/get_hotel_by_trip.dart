// lib/use_cases/get_hotel_by_trip.dart

import 'package:mallorcaplanner/domain/repositories/hotel_repository.dart';
import 'package:mallorcaplanner/entities/hotel.dart';

class GetHotelByTrip {
  final HotelRepository repository;

  GetHotelByTrip(this.repository);

  Future<Hotel> call(String tripId) async {
    return await repository.getHotelByTrip(tripId);
  }
}