import 'package:flutter/material.dart';
import 'bottom_bar.dart';
import 'start_page.dart';
import 'details_page.dart';
import 'location_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_data_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  SearchResultsPage({required this.query});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  TextEditingController searchController = TextEditingController();
  int _currentIndex = 1;
  List<String> selectedCategories = [];
  List<dynamic> userFavorites = [];

  @override
  void initState() {
    super.initState();
    _loadUserFavorites();
    searchController.text = widget.query;

    searchController.addListener(() {
      setState(() {}); // Aktualisiert die Oberfläche bei Textänderungen
    });
  }

  _loadUserFavorites() async {
    final userId = BlocProvider.of<AppDataBloc>(context).state.userId;

    final docRef =
        FirebaseFirestore.instance.collection('favoriten').doc(userId);
    final doc = await docRef.get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        userFavorites = doc.data()?['locations'];
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc, AppData>(builder: (context, appData) {
      // Hier haben Sie Zugriff auf appData.locations und appData.categories

      final locations = appData.locations;
      final categories = appData.categories;
      Trip userTrip = appData.userTrip!;
      // Ihr ursprünglicher Code für Scaffold und weiteren UI-Aufbau kommt hier:
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Suchen',
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  searchController.clear();
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height:
                    50.0, // Sie können die Höhe an Ihre Bedürfnisse anpassen.
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(categories[index]['name']),
                        selected: selectedCategories
                            .contains(categories[index]['name']),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedCategories.add(categories[index]['name']);
                            } else {
                              selectedCategories
                                  .remove(categories[index]['name']);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  if ((selectedCategories.isEmpty ||
                          (locations[index]['categories'] as List<dynamic>).any(
                              (category) =>
                                  selectedCategories.contains(category))) &&
                      locations[index]['displayName']
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                    return Slidable(
                        key: ValueKey(index),
                        startActionPane: ActionPane(
                          motion: const BehindMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              label: (!userTrip.tripLocations
                                      .contains(locations[index]['id']))
                                  ? '  Add \n  to \n  trip'
                                  : 'Remove\n  from\n  trip',
                              backgroundColor: (!userTrip.tripLocations
                                      .contains(locations[index]['id']))
                                  ? Colors.green
                                  : Colors.red,
                              icon: (!userTrip.tripLocations
                                      .contains(locations[index]['id']))
                                  ? Icons.add
                                  : Icons.remove,
                              onPressed: (context) {
                                (!userTrip.tripLocations
                                        .contains(locations[index]['id']))
                                    ? _addToCurrentTrip(locations[index]['id'])
                                    : _removeFromCurrentTrip(
                                        locations[index]['id']);
                                // Hier führen Sie die Logik aus, um das Element zur Firebase-Datenbank hinzuzufügen
                                // Zum Beispiel:
                                // final tripRef = FirebaseFirestore.instance.collection('trips').doc(userId);
                                // tripRef.set({ 'locations': FieldValue.arrayUnion([locations[index]]) });
                              },
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  location: locations[index],
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
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image.asset(
                                          locations[index]['image'],
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
                                              locations[index]['displayName'],
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
                                            IconButton(
                                              icon: Icon(
                                                Icons.star,
                                                color: userFavorites.contains(
                                                        locations[index]['id'])
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                              ), // Für den Fall, dass dieser Ort nicht in den Favoriten ist
                                              onPressed: () async {
                                                final userId = BlocProvider.of<
                                                        AppDataBloc>(context)
                                                    .state
                                                    .userId;
                                                final locationId =
                                                    locations[index]['id'];

                                                if (userFavorites
                                                    .contains(locationId)) {
                                                  userFavorites
                                                      .remove(locationId);
                                                } else {
                                                  userFavorites.add(locationId);
                                                }

                                                // Lokalen Zustand aktualisieren
                                                setState(() {});

                                                // Firestore aktualisieren
                                                await FirebaseFirestore.instance
                                                    .collection('favoriten')
                                                    .doc(userId)
                                                    .set({
                                                  'locations': userFavorites
                                                });
                                              },
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
                                            ...getCategoryImages(
                                                    appData.categories,
                                                    locations[index]
                                                        ['categories'])
                                                .map((imgPath) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Image.asset(
                                                  imgPath,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              );
                                            }).toList(),
                                            const SizedBox(width: 16),
                                            Text(
                                              locations[index]['address'],
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
                                    height:
                                        10.0), // Abstand zwischen den Bildern
                                const Divider(),
                              ],
                            ),
                          ),
                        ));
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
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
    });
  }

  List<String> getCategoryImages(
      List<dynamic> categories, List<dynamic> locationCategories) {
    List<String> images = [];
    for (var lcategory in categories) {
      if (locationCategories.contains(lcategory['name']))
        images.add(lcategory['image']);
    }
    return images;
  }

  Future<void> _addToCurrentTrip(String locationId) async {
    Trip userTrip = BlocProvider.of<AppDataBloc>(context).state.userTrip!;

    final userId = BlocProvider.of<AppDataBloc>(context).state.userId;
    CollectionReference reisen =
        FirebaseFirestore.instance.collection('reisen');

    QuerySnapshot querySnapshot =
        await reisen.where('owner', isEqualTo: userId).get();
    Map<String, dynamic> data =
        querySnapshot.docs[0].data() as Map<String, dynamic>;
    List<dynamic> tripLocations = data['locations'];
    if (!tripLocations.contains(locationId)) {
      tripLocations.add(locationId);
      await reisen.doc(querySnapshot.docs[0].id).update({
        'locations': tripLocations,
      });
      userTrip.tripLocations = tripLocations;
    }
    BlocProvider.of<AppDataBloc>(context).add(SetUserTrip(userTrip));
    setState(() {
      userTrip = userTrip;
    });
    // Hier könnten Sie weitere Logik hinzufügen, um den aktuellen Trip des Benutzers zu erhalten und den Ort dem Trip hinzuzufügen.
    // Zum Beispiel:
  }

  Future<void> _removeFromCurrentTrip(String locationId) async {
    Trip userTrip = BlocProvider.of<AppDataBloc>(context).state.userTrip!;
    final userId = BlocProvider.of<AppDataBloc>(context).state.userId;
    CollectionReference reisen =
        FirebaseFirestore.instance.collection('reisen');

    QuerySnapshot querySnapshot =
        await reisen.where('owner', isEqualTo: userId).get();
    Map<String, dynamic> data =
        querySnapshot.docs[0].data() as Map<String, dynamic>;
    List<dynamic> tripLocations = data['locations'];
    if (tripLocations.contains(locationId)) {
      tripLocations.remove(locationId);
      await reisen.doc(querySnapshot.docs[0].id).update({
        'locations': tripLocations,
      });
      userTrip.tripLocations = tripLocations;
    }

    BlocProvider.of<AppDataBloc>(context).add(SetUserTrip(userTrip));
    setState(() {
      userTrip = userTrip;
    });
  }
}
