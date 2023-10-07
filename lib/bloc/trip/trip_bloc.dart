// lib/bloc/trip_/trip__bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/trip/trip_event.dart';
import 'package:mallorcaplanner/bloc/trip/trip_state.dart';
import 'package:mallorcaplanner/domain/repositories/category_repository.dart';
import 'package:mallorcaplanner/domain/repositories/hotel_repository.dart';
import 'package:mallorcaplanner/domain/repositories/location_repository.dart';
import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository tripRepository;
  final LocationRepository locationRepository;
  final CategoryRepository categoryRepository;
  final HotelRepository hotelRepository;

  TripBloc(this.tripRepository, this.locationRepository, this.categoryRepository, this.hotelRepository) : super(TripInitial());

  @override
  Stream<TripState> mapEventToState(TripEvent event) async* {
    if (event is LoadTripDetailsEvent) {
      yield TripLoading();
      try {
        final Trip trip = await tripRepository.getTripByCurrentUser();
        final locations = await locationRepository.getAllLocations();
        final categories = await categoryRepository.getAllCategories();
        final Hotel hotel = await hotelRepository.getHotelByTrip(trip);

        yield TripLoaded(trip, locations, categories, hotel);
      } catch (e) {
        yield TripError(e.toString());
      }
    } else if (event is UpdateTripEvent) {
      try {
        tripRepository.editTrip(event.updatedTrip);
        final Trip trip = await tripRepository.getTripByCurrentUser();
        final locations = await locationRepository.getAllLocations();
        final categories = await categoryRepository.getAllCategories();
        final Hotel hotel = await hotelRepository.getHotelByTrip(trip);

        yield TripLoaded(trip, locations, categories, hotel);
      } catch (e) {
        yield TripError(e.toString());
      }
    } else if (event is DeleteTripEvent) {
      try {
        tripRepository.deleteTrip(event.tripToDelete);
        final Trip trip = await tripRepository.getTripByCurrentUser();
        final locations = await locationRepository.getAllLocations();
        final categories = await categoryRepository.getAllCategories();
        final Hotel hotel = await hotelRepository.getHotelByTrip(trip);

        yield TripLoaded(trip, locations, categories, hotel);
      } catch (e) {
        yield TripError(e.toString());
      }
    }
  }
}
