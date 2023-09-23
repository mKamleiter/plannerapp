class Category {
  final String id;
  final String name;
  final String imageUrl;
  // Weitere Felder, die für eine Category relevant sind...

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    // Weitere Konstruktorparameter...
  });

  // Optional: Eine Methode zum Konvertieren eines Firestore-Dokuments in ein Category-Objekt
  factory Category.fromFirestore(Map<String, dynamic> data) {
    print("Categorydata: $data");

    return Category(
      id: data['id'],
      name: data['name'],
      imageUrl: data['image'],
    );
  }
}
