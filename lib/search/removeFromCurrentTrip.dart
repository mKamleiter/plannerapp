import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallorcaplanner/app_data_bloc.dart';


Future<void> removeFromCurrentTrip(String locationId, context) async {
  Trip userTrip = BlocProvider.of<AppDataBloc>(context).state.userTrip!;
  final userId = BlocProvider.of<AppDataBloc>(context).state.userId;
  CollectionReference reisen = FirebaseFirestore.instance.collection('reisen');

  QuerySnapshot querySnapshot = await reisen.where('owner', isEqualTo: userId).get();
  Map<String, dynamic> data = querySnapshot.docs[0].data() as Map<String, dynamic>;
  List<dynamic> tripLocations = data['locations'];
  
  if (tripLocations.contains(locationId)) {
    tripLocations.remove(locationId);
    await reisen.doc(querySnapshot.docs[0].id).update({
      'locations': tripLocations,
    });
    userTrip.tripLocations = tripLocations;
  }
  
  BlocProvider.of<AppDataBloc>(context).add(SetUserTrip(userTrip));
}