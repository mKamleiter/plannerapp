// lib/data/repositories/firebase_location_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:mallorcaplanner/domain/repositories/location_repository.dart';
import 'package:mallorcaplanner/entities/location.dart';

class FirebaseLocationRepository implements LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<List<Location>> getAllLocations() async {
    try {
      CollectionReference locationRef = _firestore.collection('locations');
      print(locationRef);
      QuerySnapshot locationSnapshot = await locationRef.get();
      return locationSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // ID zu Data hinzufügen
        data['id'] = doc.id;
        // Cast von GeoPoint auf LatLng
        dynamic tCoords = data['location'];
        data['location'] = LatLng((tCoords as GeoPoint).latitude, (tCoords).longitude);

        // Cast von categories auf List<String>
        data['categories'] = data['categories'].cast<String>();

        return Location.fromFirestore(data);
      }).toList();
    } catch (e) {
      print("Error: $e");
      throw Exception("Fehler beim laden der Locations");
    }
  }

  @override
  Future<List<Location>> getLocationsByCategory(String category) async {
    CollectionReference locationRef = _firestore.collection('locations');
    QuerySnapshot locationSnapshot = await locationRef.where('categories', arrayContains: category).get();

    return locationSnapshot.docs.map((doc) => Location.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Location>> getLocationsByTrip(String tripId) async {
    DocumentSnapshot tripSnapshot = await _firestore.collection('reisen').doc(tripId).get();
    if (!tripSnapshot.exists) {
      return [];
    }
    Map<String, dynamic> tripData = tripSnapshot.data() as Map<String, dynamic>;
    List<String> locationIds = List<String>.from(tripData['locations'] ?? []);
    List<Location> locations = [];
    for (String locationId in locationIds) {
      DocumentSnapshot locationSnapshot = await _firestore.collection('locations').doc(locationId).get();
      if (locationSnapshot.exists) {
        locations.add(Location.fromFirestore(locationSnapshot.data() as Map<String, dynamic>));
      }
    }

    return locations;
  }

  // TODO: Implementieren Sie weitere Methoden...
}
