import 'package:flutter/material.dart';
import 'package:mallorcaplanner/bloc/profile/profile_bloc.dart';
import 'package:mallorcaplanner/bloc/profile/profile_event.dart';
import 'package:mallorcaplanner/bloc/profile/profile_state.dart';
import 'package:mallorcaplanner/presentation/widgets/bottom_bar.dart';
import 'package:mallorcaplanner/use_cases/auth_google.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3; // Nehmen wir an, dass das Profil-Icon Index 3 hat

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userId;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoading) {
        return const CircularProgressIndicator();
      } else if (state is ProfileLoaded) {
        return Scaffold(
            appBar: AppBar(title: Text('Profil & Einstellungen')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Zentriert die Buttons vertikal
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
                  SizedBox(height: 20), // Fügt einen vertikalen Abstand zwischen den Buttons hinzu
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
                  Text("User ID: "), // Zeigt die userId aus dem Zustand an
                  // Text(
                  //     "Locations: ${appDataBloc.state.locations}"), // Zeigt die locations aus dem Zustand an
                  // Text(
                  //     "Categories: ${appDataBloc.state.categories}"), // Zeigt die categories aus dem Zustand an
                ],
              ),
            ),
            bottomNavigationBar: CustomBottomBar(currentIndex: _currentIndex));
      } else {
        return Container();
      }
    });
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
