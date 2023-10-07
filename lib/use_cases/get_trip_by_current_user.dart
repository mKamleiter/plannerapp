// lib/use_cases/get_hotel_by_trip.dart

import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class GetTripByUser {
  final TripRepository repository;

  GetTripByUser(this.repository);

  Future<Trip> call() async {
    return await repository.getTripByCurrentUser();
  }
}