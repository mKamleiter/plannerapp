import 'package:mallorcaplanner/entities/category.dart';

List<String> getImagesOfCategories(List<Category> categories, List<dynamic> locationCategories) {
  List<String> images = [];
  for (var lcategory in categories) {
    if (locationCategories.contains(lcategory.name)) images.add(lcategory.imageUrl);
  }
  return images;
}
