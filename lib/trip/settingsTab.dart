import 'package:flutter/material.dart';
import 'package:mallorcaplanner/app_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tripEdit.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab();

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  // late String tripName;
  // late DateTime startDate;
  // late DateTime endDate;

  void _editTrip(Trip userTrip) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripEditPage(
          userTrip: userTrip,
        ),
      ),
    );
    // if (result != null) {
    //   setState(() {
    //     tripName = result['tripName'];
    //     startDate = result['startDate'];
    //     endDate = result['endDate'];
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    // Hier initialisieren wir die Variablen. Es wäre besser, die Initialwerte von einem obergeordneten Widget zu übernehmen.
    // tripName = widget.userTrip.tripName;
    // startDate = widget.userTrip.startDate;
    // endDate = widget.userTrip.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final appDataBloc = BlocProvider.of<AppDataBloc>(context);
    Trip userTrip = appDataBloc.state.userTrip!;
    String? currentUserId = appDataBloc.state.userId;

    // Ihr _settingsTab Code hier, z.B.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Settings', style: TextStyle(fontSize: 24)),
          Divider(),
          Text('Titel der Reise'),
          Text(userTrip.tripName),
          Divider(),
          Text('Besitzer'),
          Text(userTrip.owner),
          Divider(),
          ElevatedButton(
            onPressed: () => _editTrip(userTrip),
            child: Text('Trip bearbeiten'),
          ),
          Divider(),
          ElevatedButton(
            onPressed: userTrip.owner == currentUserId
                ? () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Trip löschen'),
                        content: Text(
                            'Sind Sie sicher, dass Sie diesen Trip löschen möchten?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Dialog schließen
                            },
                            child: Text('Abbrechen'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('reisen')
                                  .doc(userTrip.id)
                                  .delete();
                              appDataBloc.add(TripDeletedEvent(userTrip.id));
                              setState(() {
                                userTrip = appDataBloc.state.userTrip!;
                              });
                              Navigator.of(context).pop(); // Dialog schließen
                              Navigator.of(context)
                                  .pop(); // Zurück zur vorherigen Seite
                            },
                            child: Text('Löschen'),
                          ),
                        ],
                      ),
                    );
                  }
                : null, // Deaktiviert den Button, wenn der Benutzer nicht der Owner ist
            child: Text('Trip löschen'),
          ),
        ],
      ),
    );
  }
}
