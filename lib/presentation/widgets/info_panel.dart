import 'package:flutter/material.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'opening_hours.dart';

class InfoPanelContent extends StatelessWidget {
  final Location? selectedLocation;

  InfoPanelContent({required this.selectedLocation});

  @override
  Widget build(BuildContext context) {
    print(selectedLocation);
    if (selectedLocation == null) {
      return const Center(child: Text('Tippe auf eine Location!'));
    }
    return Column(
      children: [
        Text(
          selectedLocation!.displayName ?? 'Unbekannt',
          style: const TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 51, 51, 51)),
        ),
        const Divider(),
        Image.asset(
            selectedLocation!.imageUrl ?? "image/assets/imageplatzhalter.png",
            height: 100), // Bild der Location
        const Divider(),
        const Text(
          'Beschreibung',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(selectedLocation!.description ?? ''),
        const Divider(),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Öffnungszeiten',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Öffnungszeiten mit Uhr-Symbol
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: OpeningHoursContent(
              openingHours: selectedLocation!.openingHours),
        ),
        // Hier können Sie weitere Informationen hinzufügen
      ],
    );
  }
}
