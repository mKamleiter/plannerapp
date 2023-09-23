// lib/bloc/map_bloc/map_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/map_bloc/map_event.dart';
import 'package:mallorcaplanner/bloc/map_bloc/map_state.dart';
import 'package:mallorcaplanner/domain/repositories/category_repository.dart';
import 'package:mallorcaplanner/domain/repositories/location_repository.dart';
import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationRepository locationRepository;
  final CategoryRepository categoryRepository;
  final TripRepository tripRepository;

  MapBloc(this.locationRepository, this.categoryRepository, this.tripRepository) : super(MapInitial());

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is LoadAllLocationsEvent) {
      yield MapLoading();
      try {
        final locations = await locationRepository.getAllLocations();
        print(locations);
        final categories = await categoryRepository.getAllCategories();
        print(categories);
        final trip = await tripRepository.getTripByCurrentUser();
        yield MapLoaded(locations, categories, trip);
      } catch (e) {
        yield MapError(e.toString());
      }
    }
    if (event is LoadTripByCurrentUser) {
      yield MapLoading();
      try {
        final locations = await locationRepository.getAllLocations();
        print(locations);
        final categories = await categoryRepository.getAllCategories();
        print(categories);
        final trip = await tripRepository.getTripByCurrentUser();
        yield MapLoaded(locations, categories, trip);
      } catch (e) {
        yield MapError(e.toString());
      }
    }
  }
}
