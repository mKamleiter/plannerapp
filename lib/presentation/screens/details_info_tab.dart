import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/details/details_bloc.dart';
import 'package:mallorcaplanner/bloc/details/details_state.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/presentation/screens/map.dart';
import 'package:mallorcaplanner/presentation/widgets/opening_hours.dart';
// (Fügen Sie hier weitere benötigte Importe ein...)

class DetailsInfo extends StatefulWidget {
  final Location location;

  DetailsInfo({required this.location});

  @override
  _DetailsInfoState createState() => _DetailsInfoState();
}

class _DetailsInfoState extends State<DetailsInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(builder: (context, state) {
      if (state is DetailsLoading) {
        return CircularProgressIndicator();
      } else if (state is DetailsLoaded) {

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
                  widget.location.imageUrl,
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
                widget.location.description,
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
              Padding(padding: const EdgeInsets.only(left: 8.0, top: 8.0), child: OpeningHoursContent(openingHours: widget.location.openingHours)),
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
                      widget.location.address,
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
                          selectedLocationId: widget.location.id, // TODO: add selected Location
                          zoomLevel: 18.0,
                          center: widget.location.coordinates),
                    ),
                  );
                },
              )
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
