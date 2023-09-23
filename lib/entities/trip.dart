class Trip {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String owner;
  final String name;
  final List<String> locations;
  final String hotel;
  // Weitere Felder, die für eine Hotel relevant sind...

  Trip({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.owner,
    required this.name,
    required this.locations,
    required this.hotel,
  });

  // Optional: Eine Methode zum Konvertieren eines Firestore-Dokuments in ein Hotel-Objekt
  factory Trip.fromFirestore(Map<String, dynamic> data) {
    print("Tripdata: $data");

    return Trip(id: data['id'], startDate: data['startdate'], endDate: data['enddate'], owner: data['owner'], name: data['name'], hotel: data['hotelId'], locations: data['locations']);
  }
}
