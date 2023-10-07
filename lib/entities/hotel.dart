import 'package:latlong2/latlong.dart';

class Hotel {
  final String id;
  final String displayName;
  final String address;
  final LatLng coordinates;
  // Weitere Felder, die für eine Hotel relevant sind...

  Hotel({
    required this.id,
    required this.displayName,
    required this.address,
    required this.coordinates,
    // Weitere Konstruktorparameter...
  });

  // Optional: Eine Methode zum Konvertieren eines Firestore-Dokuments in ein Hotel-Objekt
  factory Hotel.fromFirestore(Map<String, dynamic> data) {
    return Hotel(id: data['id'], displayName: data['name'], address: data['adresse'], coordinates: data['location']);
  }
}
