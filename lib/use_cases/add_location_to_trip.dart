import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class AddLocationToTrip {
  final TripRepository repository;

  AddLocationToTrip(this.repository);

  Future<void> call(Location location, Trip trip) {
    return repository.addLocationToTrip(location, trip);
  }
}