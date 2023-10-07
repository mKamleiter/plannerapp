// lib/use_cases/get_all_locations.dart

import 'package:mallorcaplanner/domain/repositories/location_repository.dart';
import 'package:mallorcaplanner/entities/location.dart';

class GetAllLocations {
  final LocationRepository repository;

  GetAllLocations(this.repository);

  Future<List<Location>> call() async {
    return await repository.getAllLocations();
  }
}