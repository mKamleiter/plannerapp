import 'package:mallorcaplanner/entities/category.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<Location> locations;
  final List<Category> categories;
  final Trip trip;
  MapLoaded(this.locations, this.categories, this.trip);
}

class MapError extends MapState {
  final String message;

  MapError(this.message);
}