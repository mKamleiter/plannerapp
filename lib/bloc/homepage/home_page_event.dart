import 'package:mallorcaplanner/entities/trip.dart';

abstract class HomepageEvent {}

class LoadHomepageEvent extends HomepageEvent {
  LoadHomepageEvent();
}

class UpdateHomepageEvent extends HomepageEvent {
  final Trip updatedTrip;
  UpdateHomepageEvent(this.updatedTrip);
  
}
