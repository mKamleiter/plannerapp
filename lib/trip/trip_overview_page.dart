import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../details_page.dart';
import '../helper/images.dart';
import '../app_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'locationsTab.dart';
import 'settingsTab.dart';

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
    _loadTripData();
  }

  Future<void> _loadTripData() async {
    try {
      DocumentSnapshot tripDocument = await FirebaseFirestore.instance
          .collection('reisen')
          .doc(widget.tripId)
          .get();
      // setState(() {
      //   tripName = tripDocument['name'];
      //   startDate = (tripDocument['startdate'] as Timestamp).toDate();
      //   endDate = (tripDocument['enddate'] as Timestamp).toDate();
      //   tripLocations = tripDocument['locations'];
      //   owner = tripDocument['owner'];
      // });
    } catch (e) {
      print("Error loading trip data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadTripData();
    final appDataBloc = BlocProvider.of<AppDataBloc>(context);
    setState(() {
      categories = appDataBloc.state.categories;
      locations = appDataBloc.state.locations;
    });
    return DefaultTabController(
      length: 2, // Anzahl der Tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Trip Overview'),
          bottom: TabBar(
            tabs: [
              Tab(text: "Info"),
              Tab(text: "Settings"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LocationTab(
              categories: categories,
              locations: locations,
            ),
            SettingsTab(
            ),
          ],
        ),
      ),
    );
  }
}
