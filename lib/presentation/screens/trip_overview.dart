import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/trip/trip_bloc.dart';
import 'package:mallorcaplanner/bloc/trip/trip_event.dart';
import 'package:mallorcaplanner/bloc/trip/trip_state.dart';
import 'package:mallorcaplanner/presentation/screens/settings_tab.dart';

import 'locations_tab.dart';

class TripOverviewPage extends StatefulWidget {
  final String tripId;

  const TripOverviewPage({required this.tripId});

  @override
  _TripOverviewPageState createState() => _TripOverviewPageState();
}

class _TripOverviewPageState extends State<TripOverviewPage> {
  String tripName = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<dynamic> tripLocations = [];
  String owner = '';
  List<dynamic> categories = [];
  List<dynamic> locations = [];

  @override
  void initState() {
    super.initState();
    context.read<TripBloc>().add(LoadTripDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripBloc, TripState>(builder: (context, state) {
      if (state is TripLoading) {
        return const CircularProgressIndicator();
      } else if (state is TripLoaded) {
        final trip = state.trip;
        return DefaultTabController(
            length: 2, // Anzahl der Tabs
            child: Scaffold(
              appBar: AppBar(
                title: Text(trip.name),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Info"),
                    Tab(text: "Settings"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  LocationTab(),
                  const SettingsTab(),
                ],
              ),
            ));
      } else {
        return Container();
      }
    });
  }
}
