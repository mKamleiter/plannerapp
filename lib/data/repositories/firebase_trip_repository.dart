// lib/data/repositories/firebase_trip_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/entities/trip.dart';
import 'package:mallorcaplanner/use_cases/get_current_user.dart';

class FirebaseTripRepository implements TripRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Trip> getTripById(String tripId) async {
    DocumentSnapshot tripSnapshot = await _firestore.collection('reisen').doc(tripId).get();

    return Trip.fromFirestore(tripSnapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<Trip> getTripByCurrentUser() async {
    String currentUserId = await getCurrentUserId() as String;
    CollectionReference tripRef = _firestore.collection('reisen');

    QuerySnapshot tripSnapshot = await tripRef.where('owner', isEqualTo: currentUserId).get();

    Map<String, dynamic> data = tripSnapshot.docs[0].data() as Map<String, dynamic>;
    data['id'] = tripSnapshot.docs[0].id;
    data['startdate'] = data['startdate'].toDate();
    data['enddate'] = data['enddate'].toDate();
    List<String> locations = List<String>.from(data['locations'] ?? []);
    data['locations'] = locations;
    return Trip.fromFirestore(data);
  }
}
