import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/homepage/home_page_bloc.dart';
import 'package:mallorcaplanner/bloc/homepage/home_page_event.dart';
import 'package:mallorcaplanner/bloc/homepage/home_page_state.dart';
import 'package:mallorcaplanner/data/repositories/firebase_hotel_repository.dart';
import 'package:mallorcaplanner/entities/trip.dart';
import 'package:mallorcaplanner/presentation/screens/profile.dart';
import 'package:mallorcaplanner/presentation/screens/search_results.dart';
import 'package:mallorcaplanner/presentation/screens/trip_overview.dart';
import 'package:mallorcaplanner/presentation/widgets/bottom_bar.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List _categories = [];
  final int _currentIndex = 0;
  final String _tripId = "";
  Trip? userTrip;
  String? userId;
  //final TextEditingController _searchController = TextEditingController();
  final hotelRepository = FirebaseHotelRepository();

  @override
  void initState() {
    super.initState();
    context.read<HomepageBloc>().add(LoadHomepageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
      if (state is HomepageLoading) {
        return const CircularProgressIndicator();
      } else if (state is HomepageLoaded) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Planlos'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle),
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
                  decoration: const BoxDecoration(
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
                      onSubmitted: (query) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultsPage(query: query)));
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
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
                    child: const Divider(),
                  ),
                ),
                // Featured Überschrift zentriert
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Meine Reise', style: TextStyle(fontSize: 24)),
                  ),
                ),
                GestureDetector(
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: Colors.grey)),
                        child: Image.asset('assets/images/imageplatzhalter.png'))),
                const Divider(),
                // Categories Überschrift zentriert
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Categories', style: TextStyle(fontSize: 24)),
                  ),
                ),
                // Grid für Kategorien
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      } else {
        return Container();
      }
    });
  }
}
