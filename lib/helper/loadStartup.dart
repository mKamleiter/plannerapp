import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallorcaplanner/app_data_bloc.dart';
Future<List<Map<String, dynamic>>> loadLocationsFromFirestore() async {
  List<Map<String, dynamic>> locations = [];
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('locations');
  QuerySnapshot querySnapshot = await collectionRef.get();

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id; // Fügt die Dokument-ID als "id" hinzu

    // Konvertieren Sie Geopoint in Breiten- und Längengrade
    if (data['location'] is GeoPoint) {
      data['latitude'] = (data['location'] as GeoPoint).latitude;
      data['longitude'] = (data['location'] as GeoPoint).longitude;
      data.remove('location'); // Entfernt den Geopunkt aus den Daten
    }

    locations.add(data);
  }

  return locations;
}

Future<List<Map<String, dynamic>>> loadCategoriesFromFirestore() async {
  List<Map<String, dynamic>> categories = [];
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('categories');
  QuerySnapshot querySnapshot = await collectionRef.get();

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id; // Fügt die Dokument-ID als "id" hinzu

    categories.add(data);
  }

  return categories;
}

Future<Trip> loadUserTripFromFirestore(String? userId) async {
  Trip userTrip = Trip(tripName: "", startDate: DateTime.now(), endDate: DateTime.now(), owner: "", tripLocations: [""], id: "", hotelId: "test");
  CollectionReference reisen = FirebaseFirestore.instance.collection('reisen');

  QuerySnapshot querySnapshot = await reisen.where('owner', isEqualTo: userId).get();
  try {
    Map<String, dynamic> data = querySnapshot.docs[0].data() as Map<String, dynamic>;
    userTrip.endDate = data['enddate'].toDate();
    userTrip.startDate = data['startdate'].toDate();
    userTrip.owner = data['owner'];
    userTrip.tripName = data['name'];
    userTrip.tripLocations = data['locations'];
    userTrip.id = querySnapshot.docs[0].id;
    userTrip.hotelId = data['hotelId'];
  } catch (e) {
    print("Error loading user trip data: $e");
  }
  return userTrip;
}
