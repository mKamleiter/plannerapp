// lib/domain/repositories/hotel_repository.dart

import 'package:mallorcaplanner/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  // Weitere Methoden, die Sie benötigen...
}