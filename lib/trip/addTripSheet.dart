import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:mallorcaplanner/trip/hotelsuggestions.dart';
import 'package:mallorcaplanner/trip/addNewTrip.dart';

// Importieren Sie weitere benötigte Pakete hier

class AddTripSheetWidget extends StatefulWidget {
  const AddTripSheetWidget({Key? key}) : super(key: key);

  @override
  _AddTripSheetWidgetState createState() => _AddTripSheetWidgetState();
}

class _AddTripSheetWidgetState extends State<AddTripSheetWidget> {
  final TextEditingController _hotelNameController = TextEditingController();

  String? _tripName;
  String? _hotelName;
  String? _hotelId;
  DateTimeRange? _pickedDateRange;
  String? userId;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTimeRange? newPickedDate = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 3))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (newPickedDate != null) {
      setState(() {
        _pickedDateRange = newPickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                        setState(() {
                          _tripName = value;
                        });
                      },
                    ),
                    TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _hotelNameController,
                        decoration: InputDecoration(labelText: 'Hotelname'),
                        onChanged: (value) {
                          setState(() {
                            _hotelName = value;
                          });
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
                        setState(() {
                          _hotelName = suggestion['name'];
                          _hotelNameController.text = suggestion['name'];
                          _hotelId = suggestion['id'];
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(_pickedDateRange?.start == null ? 'Startdatum auswählen' : 'Start: ${_pickedDateRange!.start.toLocal().toString().split(' ')[0]}'),
                    ),
                    // Hier fügen Sie Ihre Datumsauswahlfelder hinzu
                    // ...
                    ElevatedButton(
                      onPressed: () {
                        if (_pickedDateRange?.start != null && _pickedDateRange?.end != null) {
                          addNewTrip(_tripName, _pickedDateRange!.start, _pickedDateRange!.end, _hotelId!, userId!);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Bestätigen'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: 50,
          ),
        ),
      ),
    );
  }
}

void showAddTripSheet(BuildContext context, DateTimeRange? pickedDateRange, String userId) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return AddTripSheetWidget();
    },
  );
}