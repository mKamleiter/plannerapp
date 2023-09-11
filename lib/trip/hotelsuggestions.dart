import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getHotelSuggestions(String query) async {
  if (query.isEmpty) {
    return [];
  }

  final querySnapshot = await FirebaseFirestore.instance
      .collection('hotels')
      .where('name', isGreaterThanOrEqualTo: query)
      .where('name', isLessThanOrEqualTo: query + '\uf8ff')
      .limit(10)
      .get();

  return querySnapshot.docs.map((doc) {
    return {
      'id': doc.id, 
      'name': doc['name']
    };
  }).toList();
}