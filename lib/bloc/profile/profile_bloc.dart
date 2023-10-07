// lib/bloc/trip_/trip__bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/profile/profile_event.dart';
import 'package:mallorcaplanner/bloc/profile/profile_state.dart';
import 'package:mallorcaplanner/domain/repositories/category_repository.dart';
import 'package:mallorcaplanner/domain/repositories/hotel_repository.dart';
import 'package:mallorcaplanner/domain/repositories/location_repository.dart';
import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final TripRepository tripRepository;
  final LocationRepository locationRepository;
  final CategoryRepository categoryRepository;
  final HotelRepository hotelRepository;

  ProfileBloc(this.tripRepository, this.locationRepository, this.categoryRepository, this.hotelRepository) : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileEvent) {
      yield ProfileLoading();
      try {
        final Trip trip = await tripRepository.getTripByCurrentUser();
        final locations = await locationRepository.getAllLocations();
        final categories = await categoryRepository.getAllCategories();
        final Hotel hotel = await hotelRepository.getHotelByTrip(trip);

        yield ProfileLoaded(trip, locations, categories, hotel);
      } catch (e) {
        yield ProfileError(e.toString());
      }
    }
  }
}
