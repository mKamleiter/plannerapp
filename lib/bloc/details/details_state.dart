import 'package:mallorcaplanner/entities/category.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final Trip trip;
  final List<Location> locations;
  final List<Category> categories;
  DetailsLoaded(this.trip, this.locations, this.categories);
}

class DetailsError extends DetailsState {
  final String message;

  DetailsError(this.message);
}
