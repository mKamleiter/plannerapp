import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallorcaplanner/app_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripEditPage extends StatefulWidget {
  Trip userTrip;

  TripEditPage({
    required this.userTrip,
  });

  @override
  _TripEditPageState createState() => _TripEditPageState();
}

class _TripEditPageState extends State<TripEditPage> {
  late TextEditingController _nameController;
  late DateTime _startDate;
  late DateTime _endDate;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userTrip.tripName);
    _startDate = widget.userTrip.startDate;
    _endDate = widget.userTrip.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateTrip() async {
    try {
      String? userId = BlocProvider.of<AppDataBloc>(context).state.userId;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('reisen')
            .doc(widget.userTrip.id)
            .update({
          'name': _nameController.text,
          'startdate': _startDate,
          'enddate': _endDate,
        });
      }
    } catch (e) {
      print("Fehler beim Aktualisieren der Reise: $e");
    }
    widget.userTrip.endDate = _endDate;
    widget.userTrip.startDate = _startDate;
    widget.userTrip.tripName = _nameController.text;
    BlocProvider.of<AppDataBloc>(context).add(SetUserTrip(widget.userTrip));
    Navigator.pop(context, {"tripName": _nameController.text, "startDate": _startDate, "endDate": _endDate});
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
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.userTrip.startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _startDate = pickedDate;
                    });
                  }
                },
                child: Text(
                    'Startdatum: ${_startDate.toLocal().toString().split(' ')[0]}'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.userTrip.endDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                },
                child: Text(
                    'Enddatum: ${_endDate.toLocal().toString().split(' ')[0]}'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateTrip,
                child: Text('Änderungen speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
