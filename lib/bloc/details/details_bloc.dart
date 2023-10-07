// lib/bloc/trip_/trip__bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/details/details_event.dart';
import 'package:mallorcaplanner/bloc/details/details_state.dart';
import 'package:mallorcaplanner/domain/repositories/category_repository.dart';
import 'package:mallorcaplanner/domain/repositories/hotel_repository.dart';
import 'package:mallorcaplanner/domain/repositories/location_repository.dart';
import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/trip.dart';
import 'package:mallorcaplanner/use_cases/add_location_to_trip.dart';
import 'package:mallorcaplanner/use_cases/remove_location_from_trip.dart';


class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final TripRepository tripRepository;
  final LocationRepository locationRepository;
  final CategoryRepository categoryRepository;

  DetailsBloc(this.tripRepository, this.locationRepository, this.categoryRepository) : super(DetailsInitial());

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is LoadDetailsEvent) {
      yield DetailsLoading();
      try {
        final Trip trip = await tripRepository.getTripByCurrentUser();
        final locations = await locationRepository.getAllLocations();
        final categories = await categoryRepository.getAllCategories();

        yield DetailsLoaded(trip, locations, categories);
      } catch (e) {
        yield DetailsError(e.toString());
      }
    } else if (event is UpdateDetailsEvent) {
      try {
        tripRepository.editTrip(event.updatedTrip);
        final Trip trip = await tripRepository.getTripByCurrentUser();
        final locations = await locationRepository.getAllLocations();
        final categories = await categoryRepository.getAllCategories();

        yield DetailsLoaded(trip, locations, categories);
      } catch (e) {
        yield DetailsError(e.toString());
      }
    } else if (event is UpdateLocationsEvent) {
      try {

        if(event.updatedTrip.locations.contains(event.locationToUpdate.id)) {
          AddLocationToTrip(tripRepository).call(event.locationToUpdate, event.updatedTrip);
        } else {
          RemoveLocationFromTrip(tripRepository).call(event.locationToUpdate, event.updatedTrip);
        }
        final Trip trip = await tripRepository.getTripByCurrentUser();
        final locations = await locationRepository.getAllLocations();
        final categories = await categoryRepository.getAllCategories();

        yield DetailsLoaded(trip, locations, categories);
      } catch (e) {
        yield DetailsError(e.toString());
      }
    }
  }
}
