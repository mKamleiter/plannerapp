import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mallorcaplanner/data/repositories/firebase_hotel_repository.dart';
import 'package:mallorcaplanner/domain/repositories/trip_repository.dart';
import 'package:mallorcaplanner/helper/getCurrentUser.dart';
//import 'package:mallorcaplanner/trip/addNewTrip.dart.old';
import 'package:mallorcaplanner/helper/loadStartup.dart';
import 'package:mallorcaplanner/presentation/screens/search_results.dart';
import 'package:mallorcaplanner/presentation/screens/trip_overview.dart';
import 'package:mallorcaplanner/presentation/widgets/bottom_bar.dart';
import 'package:mallorcaplanner/profile_page.dart';
import 'package:mallorcaplanner/use_cases/get_hotel_suggestions.dart';

import 'app_data_bloc.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List _categories = [];
  int _currentIndex = 0;
  DateTimeRange? _pickedDateRange;
  DateTime? _endDate;
  String _tripId = "";
  Trip? userTrip;
  String? userId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final TextEditingController _searchController = TextEditingController();
  final hotelRepository = FirebaseHotelRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final appDataBloc = BlocProvider.of<AppDataBloc>(context);
    loadLocationsFromFirestore().then((locations) {
      appDataBloc.add(UpdateLocations(locations));
    });

    loadCategoriesFromFirestore().then((categories) {
      appDataBloc.add(UpdateCategories(categories));
      setState(() => _categories = categories);
    });

    // appDataBloc.add(UpdateLocations(locationsData));
    //appDataBloc.add(UpdateCategories(categoriesData));

    String? fetchedUserId = await getCurrentUserId(_auth);
    if (fetchedUserId != null) {
      BlocProvider.of<AppDataBloc>(context).add(UpdateUserId(fetchedUserId));
    }

    loadUserTripFromFirestore(fetchedUserId).then((userTrip) {
      appDataBloc.add(SetUserTrip(userTrip));
      setState(() {
        userTrip;
      });
    });

    setState(() {
      userId = fetchedUserId!;
    });
  }

  void _handleSearch(String query) {
    //String query = _searchController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          query: query,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appDataBloc = BlocProvider.of<AppDataBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('MallorcaPlanner'),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            // Bild mit Suchleiste
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/hero.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  //controller: _searchController,
                  onSubmitted: _handleSearch,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Suchen...',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            // Zentrierte Trennlinie über "Featured"
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Divider(),
              ),
            ),
            // Featured Überschrift zentriert
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Meine Reise', style: TextStyle(fontSize: 24)),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('reisen').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Fehler: ${snapshot.error}'));
                }

                String? userId = appDataBloc.state.userId; // Ihre Methode zur Ermittlung der aktuellen Benutzer-ID

                if (userId != null) {
                  bool userHasTrip = false;
                  for (var doc in snapshot.data!.docs) {
                    if (doc['owner'] == userId || (doc['members'] as List).contains(userId)) {
                      userHasTrip = true;
                      _tripId = doc.id;
                      break;
                    }
                  }

                  return userHasTrip
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripOverviewPage(tripId: _tripId // Hier setzen wir den Kategorienamen als Suchbegriff
                                    ),
                              ),
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: Colors.grey)),
                              child: Image.asset('assets/images/imageplatzhalter.png')))
                      : GestureDetector(
                          onTap: _showAddTripSheet,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.0), // Fügt einen Rand horizontal hinzu
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey), // Definiert die Farbe des Randes
                              borderRadius: BorderRadius.circular(12.0), // Rundet die Ecken ab
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 50,
                              ), // oder ein geeignetes Symbol
                            ),
                          ),
                        );
                } else {
                  return Center(child: Text('Bitte melden Sie sich an.'));
                }
              },
            ),

            Divider(),
            // Categories Überschrift zentriert
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Categories', style: TextStyle(fontSize: 24)),
              ),
            ),
            // Grid für Kategorien
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(
                          query: category['name'], // Hier setzen wir den Kategorienamen als Suchbegriff
                        ),
                      ),
                    );
                  },
                  child: Image.asset(category['image']),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomBar(currentIndex: _currentIndex));
  }

  void _showAddTripSheet() {
    final TextEditingController _hotelNameController = TextEditingController();

    String? _tripName;
    String? _hotelName;
    String? _hotelAddress;
    String? _hotelId;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Neue Reise', style: TextStyle(fontSize: 24)),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name der Reise',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _tripName = value;
                      });
                    },
                  ),
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _hotelNameController,
                      decoration: InputDecoration(labelText: 'Hotelname'),
                      onChanged: (value) {
                        setState(() {
                          _hotelName = value;
                        });
                      },
                    ),
                    suggestionsCallback: (pattern) async {
                      return await GetHotelSuggestions(hotelRepository).call(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text("test"), //suggestion['name']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        _hotelName = "test"; //suggestion['name'];
                        _hotelNameController.text = "test"; //suggestion['name'];
                        _hotelId = "test"; //suggestion['id'];
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(_pickedDateRange?.start == null ? 'Startdatum auswählen' : 'Start: ${_pickedDateRange!.start.toLocal().toString().split(' ')[0]}'),
                  ),
                  // Hier fügen Sie Ihre Datumsauswahlfelder hinzu
                  // ...
                  ElevatedButton(
                    onPressed: () {
                      if (_pickedDateRange?.start != null && _pickedDateRange?.end != null) {
                        //addNewTrip(_tripName, _pickedDateRange!.start, _pickedDateRange!.end, _hotelId!, userId!);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Bestätigen'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _pickedDateRange) {
      setState(() {
        _pickedDateRange = pickedDate;
      });
    }
  }
}
