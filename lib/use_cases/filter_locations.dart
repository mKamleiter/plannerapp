// // In lib/use_cases/filter_locations.dart

// import 'package:mallorcaplanner/entities/category.dart';

// class FilterLocations {
//   List<Map<String, dynamic>> call(
//     List<Map<String, dynamic>> locations,
//     Set<Category> selectedCategories,
//     bool filterUserTripLocations,
//   ) {
//     return locations.where((location) {
//       // Filtern basierend auf userTripLocations
//       if (filterUserTripLocations) {
//         // Hier können Sie die Logik hinzufügen, um Standorte basierend auf userTripLocations zu filtern
//         // Zum Beispiel:
//         // if (!userTrip.tripLocations.contains(location['id'])) {
//         //   return false;
//         // }
//       }

//       // Wenn keine Kategorien ausgewählt sind, alle Standorte zurückgeben
//       if (selectedCategories.isEmpty) {
//         return true;
//       }

//       // Überprüfen, ob der Standort eine der ausgewählten Kategorien enthält
//       for (var category in location['categories']) {
//         if (selectedCategories.contains(category)) {
//           return true;
//         }
//       }

//       return false;
//     }).toList();
//   }
// }
// // 