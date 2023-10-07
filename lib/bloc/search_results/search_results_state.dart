import 'package:mallorcaplanner/entities/category.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class SearchResultsState {}

class SearchResultsInitial extends SearchResultsState {}

class SearchResultsLoading extends SearchResultsState {}

class SearchResultsLoaded extends SearchResultsState {
  final Trip trip;
  final List<Location> locations;
  final List<Category> categories;
  SearchResultsLoaded(this.trip, this.locations, this.categories);
}

class SearchResultsError extends SearchResultsState {
  final String message;

  SearchResultsError(this.message);
}
