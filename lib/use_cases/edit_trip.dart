import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class EditTrip {
  final TripRepository repository;

  EditTrip(this.repository);

  Future<void> call(Trip trip) {
    return repository.editTrip(trip);
  }
}