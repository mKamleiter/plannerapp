import 'package:mallorcaplanner/entities/category.dart';

List<String> getLocationCategoryImages(List<Category> categories, List<dynamic> locationCategories) {
  List<String> images = [];
  for (var category in categories) {
    if (locationCategories.contains(category.name)) images.add(category.imageUrl);
  }
  return images;
}
