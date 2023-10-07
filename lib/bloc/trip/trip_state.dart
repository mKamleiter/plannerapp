import 'package:mallorcaplanner/entities/category.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final Trip trip;
  final List<Location> locations;
  final List<Category> categories;
  final Hotel hotel;
  TripLoaded(this.trip, this.locations, this.categories, this.hotel);
}

class TripError extends TripState {
  final String message;

  TripError(this.message);
}
