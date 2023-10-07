// lib/data/repositories/firebase_Category_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallorcaplanner/domain/repositories/category_repository.dart';
import 'package:mallorcaplanner/entities/category.dart';

class FirebaseCategoryRepository implements CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      CollectionReference categoryRef = _firestore.collection('categories');
      QuerySnapshot Categoriesnapshot = await categoryRef.get();
      return Categoriesnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // ID zu Data hinzufügen
        data['id'] = doc.id;

        return Category.fromFirestore(data);
      }).toList();
    } catch (e) {
      print("Error: $e");
      throw Exception("Fehler beim laden der kategorien");
    }
  }
}
