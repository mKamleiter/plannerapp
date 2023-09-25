// lib/use_cases/get_hotel_by_trip.dart

import 'package:mallorcaplanner/domain/repositories/hotel_repository.dart';
import 'package:mallorcaplanner/entities/hotel.dart';

class GetHotelByName {
  final HotelRepository repository;

  GetHotelByName(this.repository);

  Future<Hotel> call(String name) async {
    return await repository.getHotelByName(name);
  }
}