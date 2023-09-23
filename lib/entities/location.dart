
import 'package:latlong2/latlong.dart';

class Location {
  final String id;
  final String displayName;
  final String description;
  final String imageUrl;
  final String address;
  final List<String> categories;
  final LatLng coordinates;
  final Map<String, dynamic> openingHours;
  // Weitere Felder, die für eine Location relevant sind...

  Location({
    required this.id,
    required this.displayName,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.categories,
    required this.coordinates,
    required this.openingHours
    // Weitere Konstruktorparameter...
  });

  // Optional: Eine Methode zum Konvertieren eines Firestore-Dokuments in ein Location-Objekt
  factory Location.fromFirestore(Map<String, dynamic> data) {
    print("Locationdata: $data");
    return Location(
      id: data['id'],
      displayName: data['displayName'],
      description: data['description'],
      imageUrl: data['image'],
      address: data['address'],
      coordinates: data['location'],
      categories: data['categories'],
      openingHours: data['openingHours'],
    );
  }
}
