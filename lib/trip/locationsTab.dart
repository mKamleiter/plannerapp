import 'package:flutter/material.dart';
import 'package:mallorcaplanner/helper/images.dart';
import 'package:mallorcaplanner/details_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/app_data_bloc.dart';
// (Fügen Sie hier weitere benötigte Importe ein...)

class LocationTab extends StatefulWidget {
  LocationTab();

  @override
  _LocationTabState createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
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
    List<dynamic> locations = appDataBloc.state.locations;
    List<dynamic> categories = appDataBloc.state.categories;
    List<dynamic> tripLocations = userTrip.tripLocations;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userTrip.tripName.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Titel der Reise',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  userTrip.tripName,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          Divider(),
          if (userTrip.startDate != null && userTrip.endDate != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Datum ${userTrip.startDate!.toLocal().toString().split(' ')[0]} bis ${userTrip.endDate!.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          Divider(),
          // Hier fügen Sie die Logik hinzu, um den Owner anzuzeigen
          // Sie benötigen eine zusätzliche Variable, um die Owner-Informationen zu speichern.
          if (userTrip.owner.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Owner',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  userTrip.owner,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          Divider(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Meine Locations', style: TextStyle(fontSize: 24)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userTrip.tripLocations.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          location: locations.firstWhere(
                            (entry) =>
                                entry['id'] == userTrip.tripLocations[index],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0), // Abstand horizontal
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 16,
                          height: 200,
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.asset(
                                  locations.firstWhere(
                                    (entry) =>
                                        entry['id'] ==
                                        userTrip.tripLocations[index],
                                  )['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Text(
                                      locations.firstWhere(
                                        (entry) =>
                                            entry['id'] ==
                                            userTrip.tripLocations[index],
                                      )['displayName'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 3.0,
                                            color: Colors.black,
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Positioned(
                                top: 50,
                                left: 10,
                                right: 10,
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                left: 15,
                                child: Row(
                                  children: [
                                    ...getCategoryImages(categories,
                                            locations[index]['categories'])
                                        .map((imgPath) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Image.asset(
                                          imgPath,
                                          width: 30,
                                          height: 30,
                                        ),
                                      );
                                    }).toList(),
                                    const SizedBox(width: 16),
                                    Text(
                                      locations.firstWhere(
                                        (entry) =>
                                            entry['id'] ==
                                            userTrip.tripLocations[index],
                                      )['address'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 3.0,
                                            color: Colors.black,
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: 10.0), // Abstand zwischen den Bildern
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
