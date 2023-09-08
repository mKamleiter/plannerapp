Future<List<String>> getHotelSuggestions(String query) async {
  // Hier können Sie Ihre Logik zum Abrufen der Hotelvorschläge aus einer API oder Datenbank implementieren.
  // Zum Beispiel:
  // return await MyApi.getHotelSuggestions(query);

  // Für diesen Beispielcode geben wir einfach eine festgelegte Liste von Vorschlägen zurück.
  return List<String>.generate(10, (index) => 'Hotel $query $index');
}
