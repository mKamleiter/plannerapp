import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mallorcaplanner/bloc/search_results/search_results_bloc.dart';
import 'package:mallorcaplanner/bloc/search_results/search_results_event.dart';
import 'package:mallorcaplanner/bloc/search_results/search_results_state.dart';
import 'package:mallorcaplanner/entities/trip.dart';
import 'package:mallorcaplanner/presentation/screens/details_page.dart';
import 'package:mallorcaplanner/presentation/widgets/bottom_bar.dart';
import 'package:mallorcaplanner/use_cases/get_images_of_categories.dart';

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
    context.read<SearchResultsBloc>().add(LoadSearchResultsEvent());
    searchController.text = widget.query;

    searchController.addListener(() {
      setState(() {}); // Aktualisiert die Oberfläche bei Textänderungen
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchResultsBloc, SearchResultsState>(builder: (context, state) {
      if (state is SearchResultsLoading) {
        return const CircularProgressIndicator();
      } else if (state is SearchResultsLoaded) {
        final locations = state.locations;
        final categories = state.categories;
        Trip trip = state.trip;
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
                    height: 50.0, // Sie können die Höhe an Ihre Bedürfnisse anpassen.
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Text(categories[index].name),
                            selected: selectedCategories.contains(categories[index].name),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedCategories.add(categories[index].name);
                                } else {
                                  selectedCategories.remove(categories[index].name);
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
                      if ((selectedCategories.isEmpty || (locations[index].categories).any((category) => selectedCategories.contains(category))) && locations[index].displayName.toLowerCase().contains(searchController.text.toLowerCase())) {
                        return Slidable(
                            key: ValueKey(index),
                            startActionPane: ActionPane(
                              motion: const BehindMotion(),
                              extentRatio: 0.25,
                              children: [
                                SlidableAction(
                                  label: (!trip.locations.contains(locations[index].id)) ? '  Add \n  to \n  trip' : 'Remove\n  from\n  trip',
                                  backgroundColor: (!trip.locations.contains(locations[index].id)) ? Colors.green : Colors.red,
                                  icon: (!trip.locations.contains(locations[index].id)) ? Icons.add : Icons.remove,
                                  onPressed: (context) {
                                    BlocProvider.of<SearchResultsBloc>(context).add(UpdateLocationsEvent(locations[index], trip));
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
                                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Abstand horizontal
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width - 16,
                                      height: 200,
                                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                                              locations[index].imageUrl,
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
                                                  locations[index].displayName,
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
                                                if (trip.locations.contains(locations[index].id))
                                                  Container(
                                                    margin: EdgeInsets.only(left: 5), // Abstand zwischen dem Namen und dem Hinweis
                                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Padding innerhalb des Hinweis-Containers
                                                    decoration: BoxDecoration(
                                                      color: Colors.green, // Hintergrundfarbe des Hinweis-Containers
                                                      borderRadius: BorderRadius.circular(8), // Eckenradius für abgerundete Ecken
                                                    ),
                                                    child: Text(
                                                      "Trip",
                                                      style: TextStyle(
                                                        fontSize: 12, // Schriftgröße des Hinweises
                                                        color: Colors.white, // Schriftfarbe des Hinweises
                                                        fontWeight: FontWeight.bold, // Schriftstärke des Hinweises
                                                      ),
                                                    ),
                                                  ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.star,
                                                    color: userFavorites.contains(locations[index].id) ? Colors.yellow : Colors.grey,
                                                  ),
                                                  onPressed: () async {
                                                    // TODO: add favorites on search results page
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
                                                ...getImagesOfCategories(categories, locations[index].categories).map((imgPath) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Image.asset(
                                                      imgPath,
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  );
                                                }).toList(),
                                                const SizedBox(width: 16),
                                                Text(
                                                  locations[index].address,
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
                                    const SizedBox(height: 10.0), // Abstand zwischen den Bildern
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
            bottomNavigationBar: CustomBottomBar(currentIndex: _currentIndex));
      } else {
        return Container();
      }
    });
  }
}
