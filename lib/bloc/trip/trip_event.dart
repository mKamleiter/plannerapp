import 'package:mallorcaplanner/entities/trip.dart';

abstract class TripEvent {}

class LoadTripDetailsEvent extends TripEvent {
  LoadTripDetailsEvent();
}

class UpdateTripEvent extends TripEvent {
  final Trip updatedTrip;
  UpdateTripEvent(this.updatedTrip);
  
}

class DeleteTripEvent extends TripEvent {
  final Trip tripToDelete;
  DeleteTripEvent(this.tripToDelete);
  
}
