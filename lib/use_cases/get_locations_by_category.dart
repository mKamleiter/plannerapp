// lib/use_cases/get_all_locations.dart

import 'package:mallorcaplanner/domain/repositories/location_repository.dart';
import 'package:mallorcaplanner/entities/location.dart';

class GetLocationsByCategory {
  final LocationRepository repository;

  GetLocationsByCategory(this.repository);

  Future<List<Location>> call(String category) async {
    return await repository.getLocationsByCategory(category);
  }
}