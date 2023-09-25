import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class DeleteTrip {
  final TripRepository repository;

  DeleteTrip(this.repository);

  Future<void> call(Trip trip) {
    return repository.deleteTrip(trip);
  }
}