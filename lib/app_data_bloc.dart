import 'package:flutter_bloc/flutter_bloc.dart';

class AppData {
  final String? userId;
  final List<dynamic> locations;
  final List<dynamic> categories;
  final Trip? userTrip;

  AppData({
    this.userId,
    required this.locations,
    required this.categories,
    this.userTrip,
  });

  AppData copyWith({
    String? userId,
    List<dynamic>? locations,
    List<dynamic>? categories,
    Trip? userTrip,
  }) {
    return AppData(
      userId: userId ?? this.userId,
      locations: locations ?? this.locations,
      categories: categories ?? this.categories,
      userTrip: userTrip ?? this.userTrip,
    );
  }
}

abstract class AppDataEvent {}

class SetUserTrip extends AppDataEvent {
  final Trip userTrip;

  SetUserTrip(this.userTrip);
}

class UpdateUserId extends AppDataEvent {
  final String userId;

  UpdateUserId(this.userId);
}

class UpdateLocations extends AppDataEvent {
  final List<dynamic> locations;

  UpdateLocations(this.locations);
}

class UpdateCategories extends AppDataEvent {
  final List<dynamic> categories;

  UpdateCategories(this.categories);
}

class TripDeletedEvent extends AppDataEvent {
  final String tripId;

  TripDeletedEvent(this.tripId);
}

class AppDataBloc extends Bloc<AppDataEvent, AppData> {
  AppDataBloc() : super(AppData(locations: [{}], categories: [{}]));

  @override
  Stream<AppData> mapEventToState(AppDataEvent event) async* {
    if (event is UpdateUserId) {
      yield state.copyWith(userId: event.userId);
    } else if (event is UpdateLocations) {
      yield state.copyWith(locations: event.locations);
    } else if (event is UpdateCategories) {
      yield state.copyWith(categories: event.categories);
    } else if (event is SetUserTrip) {
      yield state.copyWith(userTrip: event.userTrip);
    } else if (event is TripDeletedEvent) {
      yield state.copyWith(userTrip: null);
    }
  }
}

class Trip {
  String tripName;
  DateTime startDate;
  DateTime endDate;
  String owner;
  List<dynamic> tripLocations;
  String id;
  Trip({
    required this.tripName,
    required this.startDate,
    required this.endDate,
    required this.owner,
    required this.tripLocations,
    required this.id,
  });
}

class Hotel {
  String name;
  String address;

  Hotel({
    required this.name,
    required this.address,
  });
}
