// lib/use_cases/get_all_locations.dart
import 'package:mallorcaplanner/domain/repositories/category_repository.dart';
import 'package:mallorcaplanner/entities/category.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<List<Category>> call() async {
    return await repository.getAllCategories();
  }
}
