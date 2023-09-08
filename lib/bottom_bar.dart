import 'package:flutter/material.dart';
import 'start_page.dart';
import 'search_results_page.dart';
import 'map/location_map.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  CustomBottomBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      iconSize: 20.0,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => StartPage()),
              (Route<dynamic> route) => false,
            );
            break;

          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultsPage(query: ""),
              ),
            );
            break;

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationsMap(), // Die Seite, auf der Ihre Karte angezeigt wird
              ),
            );
            // Hier können Sie weitere Navigationen für das Profil hinzufügen
            break;

          case 3:
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Startseite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Suchen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
