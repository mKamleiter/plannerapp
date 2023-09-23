import 'package:flutter/material.dart';

class OpeningHoursContent extends StatelessWidget {
  final Map<String, dynamic> openingHours;

  OpeningHoursContent({required this.openingHours});

  @override
  Widget build(BuildContext context) {

    List<Widget> rows = [];
    for (var day in openingHours.keys) {
      rows.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                day,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                openingHours[day] ?? 'N/A',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      );
      rows.add(
          const SizedBox(height: 4.0)); // Kleinerer Abstand zwischen den Zeilen
    }

    return Column(children: rows);
  }
}
