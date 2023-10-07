// lib/data/repositories/firebase_hotel_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:mallorcaplanner/domain/repositories/hotel_repository.dart';
import 'package:mallorcaplanner/entities/hotel.dart';
import 'package:mallorcaplanner/entities/trip.dart';
import 'package:mallorcaplanner/use_cases/cast_geopoint_to_latlng.dart';

class FirebaseHotelRepository implements HotelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Hotel> getHotelByTrip(Trip trip) async {
    DocumentSnapshot tripSnapshot = await _firestore.collection('reisen').doc(trip.id).get();

    Map<String, dynamic> tripData = tripSnapshot.data() as Map<String, dynamic>;
    String hotelId = tripData['hotelId'] ?? "undefined";
    DocumentSnapshot hotelSnapshot = await _firestore.collection('hotels').doc(hotelId).get();
    Map<String, dynamic> data = hotelSnapshot.data() as Map<String, dynamic>;
    data['id'] = hotelSnapshot.id;

    dynamic tCoords = data['location'];
    data['location'] = LatLng((tCoords as GeoPoint).latitude, (tCoords).longitude);
    return Hotel.fromFirestore(data);
  }

  @override
  Future<List<Hotel>> getHotelSuggestions(String query) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('hotels')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff') // Suche mit einer Art "Begins with"-Logik
        .get();

    return snapshot.docs.map((doc) {
      return Hotel(
        id: doc.id,
        displayName: doc.get('name') ?? "",
        address: doc.get('adresse') ?? "",
        coordinates: castGeoPointToLatLng(doc.get('location')),
      );
    }).toList();
  }

  @override
  Future<Hotel> getHotelByName(String name) async {
    String hotelName = name;
    QuerySnapshot hotelSnapshot = await _firestore.collection('hotels').where('name', isEqualTo: hotelName).get();

    Map<String, dynamic> data = hotelSnapshot.docs[0].data() as Map<String, dynamic>;
    data['id'] = hotelSnapshot.docs[0].id;

    dynamic tCoords = data['location'];
    data['location'] = LatLng((tCoords as GeoPoint).latitude, (tCoords).longitude);
    return Hotel.fromFirestore(data);
  }
}
