import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/app_data_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addToCurrentTrip(String locationId, context) async {
  Trip userTrip = BlocProvider.of<AppDataBloc>(context).state.userTrip!;

  final userId = BlocProvider.of<AppDataBloc>(context).state.userId;
  CollectionReference reisen = FirebaseFirestore.instance.collection('reisen');

  QuerySnapshot querySnapshot =
      await reisen.where('owner', isEqualTo: userId).get();
  Map<String, dynamic> data =
      querySnapshot.docs[0].data() as Map<String, dynamic>;
  List<dynamic> tripLocations = data['locations'];
  if (!tripLocations.contains(locationId)) {
    tripLocations.add(locationId);
    await reisen.doc(querySnapshot.docs[0].id).update({
      'locations': tripLocations,
    });
    userTrip.tripLocations = tripLocations;
  }
  BlocProvider.of<AppDataBloc>(context).add(SetUserTrip(userTrip));
  // Hier könnten Sie weitere Logik hinzufügen, um den aktuellen Trip des Benutzers zu erhalten und den Ort dem Trip hinzuzufügen.
  // Zum Beispiel:
}
