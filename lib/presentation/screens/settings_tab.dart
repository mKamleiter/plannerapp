import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/trip/trip_bloc.dart';
import 'package:mallorcaplanner/bloc/trip/trip_state.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/trip.dart';
import 'package:mallorcaplanner/presentation/widgets/trip_edit.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab();

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {

  void _editTrip(Trip trip, Hotel hotel) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripEditPage(
          trip: trip,
          hotel: hotel,
        ),
      ),
    );

    // if (result != null) {
    //   // Hier können Sie den result-Wert verwenden, um den Trip zu bearbeiten
    //   editTripUseCase(trip);
    // }
  }

  void _deleteTrip(Trip trip) async {
    //await deleteTripUseCase(trip);
    Navigator.of(context).pop(); // Zurück zur vorherigen Seite
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripBloc, TripState>(builder: (context, state) {
      if (state is TripLoading) {
        return const CircularProgressIndicator();
      } else if (state is TripLoaded) {
        final trip = state.trip;
        final hotel = state.hotel;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Settings', style: TextStyle(fontSize: 24)),
              const Divider(),
              const Text('Titel der Reise'),
              Text(trip.name),
              const Divider(),
              const Text('Besitzer'),
              Text(trip.owner),
              const Text('Hotel'),
              Text(trip.hotel),
              const Divider(),
              ElevatedButton(
                onPressed: () => _editTrip(trip, hotel),
                child: const Text('Trip bearbeiten'),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: trip.owner == trip.owner
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Trip löschen'),
                            content: const Text('Sind Sie sicher, dass Sie diesen Trip löschen möchten?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Dialog schließen
                                },
                                child: const Text('Abbrechen'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteTrip(trip);
                                  Navigator.of(context).pop(); // Dialog schließen
                                },
                                child: const Text('Löschen'),
                              ),
                            ],
                          ),
                        );
                      }
                    : null, // Deaktiviert den Button, wenn der Benutzer nicht der Owner ist
                child: const Text('Trip löschen'),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
