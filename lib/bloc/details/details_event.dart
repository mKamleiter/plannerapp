import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class DetailsEvent {}

class LoadDetailsEvent extends DetailsEvent {
  LoadDetailsEvent();
}

class UpdateDetailsEvent extends DetailsEvent {
  final Trip updatedTrip;
  UpdateDetailsEvent(this.updatedTrip);
  
}

class UpdateLocationsEvent extends DetailsEvent {
  final Location locationToUpdate;
  final Trip updatedTrip;
  UpdateLocationsEvent(this.locationToUpdate, this.updatedTrip);
  
}