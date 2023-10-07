import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class SearchResultsEvent {}

class LoadSearchResultsEvent extends SearchResultsEvent {
  LoadSearchResultsEvent();
}

class UpdateSearchResultsEvent extends SearchResultsEvent {
  final Trip updatedTrip;
  UpdateSearchResultsEvent(this.updatedTrip);
  
}

class UpdateLocationsEvent extends SearchResultsEvent {
  final Location locationToUpdate;
  final Trip updatedTrip;
  UpdateLocationsEvent(this.locationToUpdate, this.updatedTrip);
  
}