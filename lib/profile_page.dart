import 'package:flutter/material.dart';
import 'auth_google.dart';
import 'bottom_bar.dart';
import 'start_page.dart';
import 'search_results_page.dart';
import 'location_map.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_data_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3; // Nehmen wir an, dass das Profil-Icon Index 3 hat

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userId;

  @override
  Widget build(BuildContext context) {
    final appDataBloc = BlocProvider.of<AppDataBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Profil & Einstellungen')),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Zentriert die Buttons vertikal
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final user = await AuthService().signInWithGoogle();
                if (user != null) {
                  print("Erfolgreich eingeloggt: ${user.displayName}");
                } else {
                  print("Fehler beim Einloggen");
                }
              },
              child: Text("Mit Google anmelden"),
            ),
            SizedBox(
                height:
                    20), // Fügt einen vertikalen Abstand zwischen den Buttons hinzu
            TextButton(
              onPressed: () async {
                String? fetchedUserId = await _getCurrentUserId();
                setState(() {
                  userId = fetchedUserId;
                });
                if (fetchedUserId != null) {
                  print("User ID: $fetchedUserId");
                } else {
                  print("User not logged in");
                }
              },
              child: Text("Get User ID"),
            ),
            SizedBox(height: 20),
            Text(userId ?? "No User ID available"),
            SizedBox(height: 20), // Einen weiteren Abstand hinzufügen
            // Anzeige des AppDataBloc-Zustands
            Text("AppDataBloc State:"),
            Text(
                "User ID: ${appDataBloc.state.userId ?? "No User ID in state"}"), // Zeigt die userId aus dem Zustand an
            // Text(
            //     "Locations: ${appDataBloc.state.locations}"), // Zeigt die locations aus dem Zustand an
            // Text(
            //     "Categories: ${appDataBloc.state.categories}"), // Zeigt die categories aus dem Zustand an
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

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
                  builder: (context) =>
                      LocationsMap(), // Die Seite, auf der Ihre Karte angezeigt wird
                ),
              );
              // Hier können Sie weitere Navigationen für das Profil hinzufügen
              break;

            case 3:
              break;
          }
        },
      ),
    );
  }

  Future<String?> _getCurrentUserId() async {
    try {
      final user = _auth.currentUser;
      return user?.uid;
    } catch (error) {
      print("Error getting user ID: $error");
      return null;
    }
  }
}