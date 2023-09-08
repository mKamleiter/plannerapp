import 'package:flutter/material.dart';
import 'package:mallorcaplanner/app_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHotelPage extends StatefulWidget {
  @override
  _AddHotelPageState createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage> {
  TextEditingController hotelNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // ... (andere Controller für weitere Felder)

  void saveHotel(userTrip) async{
    final hotel = Hotel(
      name: hotelNameController.text,
      address: addressController.text,
      // ... (andere Felder)
    );

    final String currentTripId = BlocProvider.of<AppDataBloc>(context).state.userTrip!.id;
    try {
      await FirebaseFirestore.instance
          .collection('reisen')
          .doc(currentTripId)
          .update({'hotel': hotel});
    }
    catch (e) {
      print("Fehler beim Speichern des Hotels: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final appDataBloc = BlocProvider.of<AppDataBloc>(context);
    Trip userTrip = appDataBloc.state.userTrip!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel hinzufügen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: hotelNameController,
              decoration: InputDecoration(labelText: 'Hotelname'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Adresse'),
            ),
            // ... (andere Textfelder für weitere Informationen)
            ElevatedButton(
              onPressed: () => saveHotel(context),
              child: Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
