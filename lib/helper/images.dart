List<String> getCategoryImages(
    List<dynamic> categories, List<dynamic> locationCategories) {
  List<String> images = [];
  for (var lcategory in categories) {
    if (locationCategories.contains(lcategory['name']))
      images.add(lcategory['image']);
  }
  return images;
}
