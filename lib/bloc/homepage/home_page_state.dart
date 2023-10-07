import 'package:mallorcaplanner/entities/category.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class HomepageState {}

class HomepageInitial extends HomepageState {}

class HomepageLoading extends HomepageState {}

class HomepageLoaded extends HomepageState {
  final Trip trip;
  HomepageLoaded(this.trip);
}

class HomepageError extends HomepageState {
  final String message;

  HomepageError(this.message);
}

class UserNotLoggedIn extends HomepageState {}

class UserLoggedInWithoutTrip extends HomepageState {}

class UserLoggedInWithTrip extends HomepageState {
  final String tripId;

  UserLoggedInWithTrip({required this.tripId});
}
