import 'package:flutter/material.dart';
import 'package:mallorcaplanner/presentation/screens/home_page.dart';
import 'package:mallorcaplanner/presentation/screens/map.dart';
import 'package:mallorcaplanner/presentation/screens/search_results.dart';


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
              MaterialPageRoute(builder: (context) => Homepage()),
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
                builder: (context) => LocationsMap(),
              ),
            );
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
