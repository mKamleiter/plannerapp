import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mallorcaplanner/bloc/trip/trip_bloc.dart';
import 'package:mallorcaplanner/bloc/trip/trip_event.dart';
import 'package:mallorcaplanner/data/repositories/firebase_hotel_repository.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/trip.dart';

class TripEditPage extends StatefulWidget {
  final Trip trip;
  final Hotel hotel;

  TripEditPage({
    required this.trip,
    required this.hotel,
  });

  @override
  _TripEditPageState createState() => _TripEditPageState();
}

class _TripEditPageState extends State<TripEditPage> {
  final hotelRepository = FirebaseHotelRepository();

  late TextEditingController _nameController;
  late TextEditingController _hotelNameController;
  late TextEditingController _hotelAddressController;

  late DateTime _startDate;
  late DateTime _endDate;
  @override
  void initState() {
    super.initState();

    // Initialisieren Sie die Controller mit den Daten von trip
    _nameController = TextEditingController(text: widget.trip.name);
    _hotelNameController = TextEditingController(text: widget.hotel.displayName);
    _hotelAddressController = TextEditingController(text: widget.hotel.address);
    _startDate = widget.trip.startDate;
    _endDate = widget.trip.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hotelNameController.dispose();
    _hotelAddressController.dispose();
    super.dispose();
  }

  void _updateTrip(Trip tripToUpdate) async{
    Hotel newHotel = widget.hotel;
    if (widget.hotel.displayName != _hotelNameController.text) {
      newHotel = await hotelRepository.getHotelByName(_hotelNameController.text);
    }
    // Erstellen Sie ein aktualisiertes Trip-Objekt
    Trip updatedTrip = Trip(
        id: widget.trip.id,
        name: _nameController.text,
        startDate: _startDate,
        owner: tripToUpdate.owner,
        endDate: _endDate,
        locations: tripToUpdate.locations,
        // Hier nehmen wir an, dass Sie eine Hotel-Entität oder ein ähnliches Objekt haben
        hotel: newHotel.id
        // Fügen Sie zusätzliche Felder hinzu, falls vorhanden
        );

    print("Update");

    // Verwenden Sie den TripBloc, um den Trip zu aktualisieren
    BlocProvider.of<TripBloc>(context).add(UpdateTripEvent(updatedTrip));

    // Schließen Sie die Seite
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip bearbeiten'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name des Trips'),
              ),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _hotelNameController,
                  decoration: InputDecoration(labelText: 'Hotelname'),
                ),
                suggestionsCallback: (pattern) async {
                  return await hotelRepository.getHotelSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.displayName),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _hotelNameController.text = suggestion.displayName;
                    _hotelAddressController.text = suggestion.address;
                  });
                },
              ),
              TextFormField(
                controller: _hotelAddressController,
                decoration: InputDecoration(labelText: 'Adresse des Hotels'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.trip.startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _startDate = pickedDate;
                    });
                  }
                },
                child: Text('Startdatum: ${_startDate.toLocal().toString().split(' ')[0]}'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.trip.endDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                },
                child: Text('Enddatum: ${_endDate.toLocal().toString().split(' ')[0]}'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _updateTrip(widget.trip),
                child: Text('Änderungen speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
