
abstract class MapEvent {}

class LoadAllLocationsEvent extends MapEvent {}

class LoadLocationsByCategoryEvent extends MapEvent {
  final String category;

  LoadLocationsByCategoryEvent(this.category,);
}

class LoadLocationsByTripEvent extends MapEvent {
  final String tripId;

  LoadLocationsByTripEvent(this.tripId);
}

class LoadHotelByTripEvent extends MapEvent {
  final String tripId;

  LoadHotelByTripEvent(this.tripId);
}

class LoadTripByIdEvent extends MapEvent {
  final String tripId;

  LoadTripByIdEvent(this.tripId);
}

class LoadTripByCurrentUser extends MapEvent {

  LoadTripByCurrentUser();
}