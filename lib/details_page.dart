import 'package:flutter/material.dart';
import 'map/location_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_data_bloc.dart';

class DetailsPage extends StatefulWidget {
  final Map location;

  DetailsPage(
      {required this.location});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<dynamic> locations = [];
  List<dynamic> categories = [];
  @override
  Widget build(BuildContext context) {
    final appDataBloc = BlocProvider.of<AppDataBloc>(context);
    setState(() {
      locations = appDataBloc.state.locations;
      categories = appDataBloc.state.categories;
    });
    return DefaultTabController(
      length: 2, // Anzahl der Tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.location['displayName']),
          bottom: TabBar(
            tabs: [
              Tab(text: "Info"),
              Tab(text: "Bilder"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _infoTab(),
            _imagesTab(),
          ],
        ),
      ),
    );
  }

  Widget _infoTab() {
    return Container(
      margin: EdgeInsets.all(16.0), // Rand um den Container
      padding: EdgeInsets.all(16.0), // Innenabstand

      decoration: BoxDecoration(
        color: Color.fromARGB(239, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(196, 158, 158, 158).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Beschreibung
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              widget.location['image'],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              'Beschreibung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            widget.location['description'] ?? 'Beschreibung nicht verfügbar',
            style: TextStyle(fontSize: 16),
          ),
          Divider(),
          // Überschrift für Öffnungszeiten
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Öffnungszeiten',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Öffnungszeiten mit Uhr-Symbol
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: _buildOpeningHours(widget.location['openingHours']),
          ),
          Divider(),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              'Adresse',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Adresse der Location
          Row(
            children: [
              Icon(Icons.location_pin, color: Colors.blue),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  widget.location['address'] ?? 'Adresse nicht verfügbar',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0), // Etwas Abstand vor dem Button
          ElevatedButton(
            child: Text("Auf der Karte anzeigen"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationsMap(
                    selectedLocationId: widget.location['id'],
                    selectedLocation: widget.location,
                    zoomLevel: 18.0,
                    center: LatLng(
                      widget.location['latitude'],
                      widget.location['longitude'],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _imagesTab() {
    return Center(
      child: Text('Hier kommen die Bilder hin'),
    );
  }

  Widget _buildOpeningHours(Map<String, dynamic>? openingHours) {
    if (openingHours == null) {
      return Text(
        'Öffnungszeiten nicht verfügbar',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    List<Widget> rows = [];
    for (var day in openingHours.keys) {
      rows.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                day,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                openingHours[day] ?? 'N/A',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      );
      rows.add(SizedBox(height: 4.0)); // Kleinerer Abstand zwischen den Zeilen
    }

    return Column(children: rows);
  }
}
