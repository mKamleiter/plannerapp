import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallorcaplanner/profile_page.dart';
import 'bottom_bar.dart';
import 'search_results_page.dart';
import 'details_page.dart';
import 'map/location_map.dart';
import 'app_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'trip/trip_overview_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mallorcaplanner/trip/hotelsuggestions.dart';


class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List _categories = [];
  List _locations = [];
  int _currentIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  String _tripId = "";
  Trip? userTrip;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<List<Map<String, dynamic>>> _loadLocationsFromFirestore() async {
    List<Map<String, dynamic>> locations = [];
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('locations');
    QuerySnapshot querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Fügt die Dokument-ID als "id" hinzu

      // Konvertieren Sie Geopoint in Breiten- und Längengrade
      if (data['location'] is GeoPoint) {
        data['latitude'] = (data['location'] as GeoPoint).latitude;
        data['longitude'] = (data['location'] as GeoPoint).longitude;
        data.remove('location'); // Entfernt den Geopunkt aus den Daten
      }

      locations.add(data);
    }

    return locations;
  }

  Future<List<Map<String, dynamic>>> _loadCategoriesFromFirestore() async {
    List<Map<String, dynamic>> categories = [];
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('categories');
    QuerySnapshot querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Fügt die Dokument-ID als "id" hinzu

      categories.add(data);
    }

    return categories;
  }

  Future<Trip> _loadUserTripFromFirestore(String? userId) async {
    Trip userTrip=Trip(tripName: "", startDate: DateTime.now(), endDate: DateTime.now(), owner: "", tripLocations: [""], id: "", hotel: Hotel(address: "", name: ""));
    CollectionReference reisen = FirebaseFirestore.instance.collection('reisen');

    QuerySnapshot querySnapshot = await reisen.where('owner', isEqualTo: userId).get();
    try {
      Map<String, dynamic> data = querySnapshot.docs[0].data() as Map<String, dynamic>;
      userTrip.endDate = data['enddate'].toDate();
      userTrip.startDate = data['startdate'].toDate();
      userTrip.owner = data['owner'];
      userTrip.tripName = data['name'];
      userTrip.tripLocations = data['locations'];
      userTrip.id = querySnapshot.docs[0].id;
      userTrip.hotel = Hotel(name: data['hotel']['name'], address: data['hotel']['address']);
      
      
    } catch (e) {
      print("Error loading user trip data: $e");
    }
    return userTrip;
  }

  void _loadData() async {
    String categoriesJson = await rootBundle.loadString('assets/categories.json');

    // String locationsJson = await rootBundle.loadString('assets/locations.json');
    // List<dynamic> locationsData = json.decode(locationsJson);

    final appDataBloc = BlocProvider.of<AppDataBloc>(context);
    _loadLocationsFromFirestore().then((locations) {
      appDataBloc.add(UpdateLocations(locations));
      setState(() => _locations = locations);
    });

    _loadCategoriesFromFirestore().then((categories) {
      appDataBloc.add(UpdateCategories(categories));
      setState(() => _categories = categories);
    });

    // appDataBloc.add(UpdateLocations(locationsData));
    //appDataBloc.add(UpdateCategories(categoriesData));

    String? fetchedUserId = await _getCurrentUserId();
    if (fetchedUserId != null) {
      BlocProvider.of<AppDataBloc>(context).add(UpdateUserId(fetchedUserId));
    }

    _loadUserTripFromFirestore(fetchedUserId).then((userTrip) {
        appDataBloc.add(SetUserTrip(userTrip));
        setState(() => userTrip = userTrip);
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

  Future<String?> _getCurrentUserId() async {
    try {
      final user = _auth.currentUser;
      return user?.uid;
    } catch (error) {
      print("Error getting user ID: $error");
      return null;
    }
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
                      return await getHotelSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        _hotelName = suggestion;
                        _hotelNameController.text = suggestion;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Hoteladresse',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _hotelAddress = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(_startDate == null ? 'Startdatum auswählen' : 'Start: ${_startDate!.toLocal().toString().split(' ')[0]}'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(_endDate == null ? 'Enddatum auswählen' : 'Ende: ${_endDate!.toLocal().toString().split(' ')[0]}'),
                  ),
                  // Hier fügen Sie Ihre Datumsauswahlfelder hinzu
                  // ...
                  ElevatedButton(
                    onPressed: () {
                      if (_startDate != null && _endDate != null) {
                        _addNewTrip(_tripName, _startDate!, _endDate!, _hotelName!, _hotelAddress!);
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

  Future<void> _addNewTrip(String? name, DateTime startDate, DateTime endDate, String hotelName, String hotelAddress) async {
    try {
      String? userId = await _getCurrentUserId();
      Hotel hotel = Hotel(name: hotelName, address: hotelAddress);
      if (userId != null) {
        await FirebaseFirestore.instance.collection('reisen').add({
          'name': name,
          'owner': userId,
          'member': [],
          'locations': [],
          'startdate': startDate,
          'enddate': endDate,
          'hotel': {
            'name': hotelName,
            'address': hotelAddress,
          },
        });
      }
    } catch (e) {
      print("Fehler beim Hinzufügen einer neuen Reise: $e");
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }
}
