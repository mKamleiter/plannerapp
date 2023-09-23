// lib/data/repositories/firebase_hotel_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallorcaplanner/domain/repositories/hotel_repository.dart';
import 'package:mallorcaplanner/entities/hotel.dart';

class FirebaseHotelRepository implements HotelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Hotel> getHotelByTrip(String tripId) async {
    DocumentSnapshot tripSnapshot = await _firestore.collection('reisen').doc(tripId).get();


    Map<String, dynamic> tripData = tripSnapshot.data() as Map<String, dynamic>;
    String hotelId = tripData['hotelId'] ?? "undefined";
    DocumentSnapshot hotelSnapshot = await _firestore.collection('hotels').doc(hotelId).get();

    return Hotel.fromFirestore(hotelSnapshot as Map<String, dynamic>);
    
  }

}
