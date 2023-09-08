import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallorcaplanner/app_data_bloc.dart';

Future<List<dynamic>?> loadUserFavorites(context) async {
  final userId = BlocProvider.of<AppDataBloc>(context).state.userId;
  final docRef = FirebaseFirestore.instance.collection('favoriten').doc(userId);
  final doc = await docRef.get();

  if (doc.exists && doc.data() != null) {
    return doc.data()?['locations'];
  }
  
  return null;
}
