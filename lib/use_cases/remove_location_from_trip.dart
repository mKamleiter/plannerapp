import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class RemoveLocationFromTrip {
  final TripRepository repository;

  RemoveLocationFromTrip(this.repository);

  Future<void> call(Location location, Trip trip) {
    return repository.removeLocationFromTrip(location, trip);
  }
}