import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mallorcaplanner/trip/hotelsuggestions.dart';

Future<void> addNewTrip(String? name, DateTime startDate, DateTime endDate, String hotelId, String userId) async {
  try {
    if (userId != null) {
      await FirebaseFirestore.instance.collection('reisen').add({'name': name, 'owner': userId, 'member': [], 'locations': [], 'startdate': startDate, 'enddate': endDate, 'hotelId': hotelId});
    }
  } catch (e) {
    print("Fehler beim Hinzufügen einer neuen Reise: $e");
  }
}

void _showAddTripSheet(BuildContext context, DateTimeRange? pickedDateRange, String userId) {
  final TextEditingController _hotelNameController = TextEditingController();

  String? _tripName;
  String? _hotelName;
  String? _hotelAddress; // Sie scheinen _hotelAddress nirgendwo zu verwenden, benötigen Sie diese Variable noch?
  String? _hotelId;

  DateTimeRange startRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 3)));

  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Neue Reise', style: TextStyle(fontSize: 24)),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name der Reise',
                ),
                onChanged: (value) {
                  _tripName = value;
                },
              ),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _hotelNameController,
                  decoration: InputDecoration(labelText: 'Hotelname'),
                  onChanged: (value) {
                    _hotelName = value;
                  },
                ),
                suggestionsCallback: (pattern) async {
                  return await getHotelSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['name']),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _hotelName = suggestion['name'];
                  _hotelNameController.text = suggestion['name'];
                  _hotelId = suggestion['id'];
                },
              ),
              // ElevatedButton(
              //   onPressed: () => _selectDate(context), // Achten Sie darauf, die Methode _selectDate in dieser Datei oder importieren Sie sie
              //   child: Text(_pickedDateRange?.start == null ? 'Startdatum auswählen' : 'Start: ${_pickedDateRange!.start.toLocal().toString().split(' ')[0]}'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     if (_pickedDateRange?.start != null && _pickedDateRange?.end != null) {
              //       addNewTrip(_tripName, _pickedDateRange!.start, _pickedDateRange!.end, _hotelId!, userId);
              //       Navigator.pop(context);
              //     }
              //   },
              //   child: Text('Bestätigen'),
              // ),
            ],
          ),
        ),
      );
    },
  );
}

Future<DateTimeRange> _selectDate(BuildContext context) async {
  DateTimeRange? pickedDate = await showDateRangePicker(
    context: context,
    initialDateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 3))),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365)),
  );
    return pickedDate!;
}
