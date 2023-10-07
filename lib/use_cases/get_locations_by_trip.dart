// lib/use_cases/get_all_locations.dart

import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/domain/repositories/location_repository.dart';

class GetLocationsByTrip {
  final LocationRepository repository;

  GetLocationsByTrip(this.repository);

  Future<List<Location>> call(String tripId) async {
    return await repository.getLocationsByTrip(tripId);
  }
}