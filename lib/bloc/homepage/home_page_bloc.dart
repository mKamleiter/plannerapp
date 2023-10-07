// lib/bloc/trip_/trip__bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/homepage/home_page_event.dart';
import 'package:mallorcaplanner/bloc/homepage/home_page_state.dart';
import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/trip.dart';


class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  final TripRepository tripRepository;

  HomepageBloc(this.tripRepository) : super(HomepageInitial());

  @override
  Stream<HomepageState> mapEventToState(HomepageEvent event) async* {
    if (event is LoadHomepageEvent) {
      yield HomepageLoading();
      try {
        final Trip trip = await tripRepository.getTripByCurrentUser();

        yield HomepageLoaded(trip);
      } catch (e) {
        yield HomepageError(e.toString());
      }
    } else if (event is UpdateHomepageEvent) {
      try {
        tripRepository.editTrip(event.updatedTrip);
        final Trip trip = await tripRepository.getTripByCurrentUser();

        yield HomepageLoaded(trip);
      } catch (e) {
        yield HomepageError(e.toString());
      }
    }
  }
}
