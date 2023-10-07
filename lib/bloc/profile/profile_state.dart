import 'package:mallorcaplanner/entities/category.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Trip trip;
  final List<Location> locations;
  final List<Category> categories;
  final Hotel hotel;
  ProfileLoaded(this.trip, this.locations, this.categories, this.hotel);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
