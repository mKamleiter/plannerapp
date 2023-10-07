// lib/use_cases/get_hotel_by_trip.dart

import 'package:mallorcaplanner/domain/repositories/hotel_repository.dart';
import 'package:mallorcaplanner/entities/hotel.dart';

class GetHotelSuggestions {
  final HotelRepository repository;

  GetHotelSuggestions(this.repository);

  Future<List<Hotel>> call(String query) async {
    return await repository.getHotelSuggestions(query);
  }
}