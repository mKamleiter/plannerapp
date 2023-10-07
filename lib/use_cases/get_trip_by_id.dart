// lib/use_cases/get_hotel_by_trip.dart

import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class GetTripById {
  final TripRepository repository;

  GetTripById(this.repository);

  Future<Trip> call(String tripId) async {
    return await repository.getTripById(tripId);
  }
}