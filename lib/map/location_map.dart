import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import '../bottom_bar.dart';
import '../start_page.dart';
import '../search_results_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_data_bloc.dart';
import 'info_panel.dart';
class LocationsMap extends StatefulWidget {
  String? selectedLocationId;
  Map<dynamic, dynamic>? selectedLocation;
  LatLng? center;
  double? zoomLevel;

  LocationsMap(
      {this.selectedLocationId,
      this.selectedLocation,
      this.center,
      this.zoomLevel});

  @override
  _LocationsMapState createState() => _LocationsMapState();
}

class _LocationsMapState extends State<LocationsMap> {
  var mapController = MapController();
  int _currentIndex = 2;
  double pminheight = 0;
  bool isCategoryWindowOpen = false;
  Set<String> _selectedCategories = {};
  bool _categoryWindowVisible = false;
  bool _filterUserTripLocations = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc, AppData>(builder: (context, appData) {
      final List<dynamic> locations = appData.locations;
      final List<dynamic> categories = appData.categories;
      Trip userTrip = appData.userTrip!;
      return Scaffold(
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
        body: SlidingUpPanel(
            minHeight: pminheight ?? 0,
            maxHeight: MediaQuery.of(context).size.height / 2,
            panel: InfoPanelContent(selectedLocation: widget.selectedLocation),
            body: Stack(children: [
              FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: widget.center ?? LatLng(39.5153, 2.7471),
                    zoom: widget.zoomLevel ?? 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/mkamleiter/clltqs61w00b601nzc36eg8ib/draft/tiles/{z}/{x}/{y}?access_token=sk.eyJ1IjoibWthbWxlaXRlciIsImEiOiJjbGx3dXNydDcwMzJmM2RwZzBpcG1rczBiIn0.r4F5JI-jpyoibpWvkfAj-Q",
                      // urlTemplate:
                      //     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      // subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        maxClusterRadius: 120,
                        size: Size(40, 40),
                        fitBoundsOptions: FitBoundsOptions(
                          padding: EdgeInsets.all(50),
                        ),
                        markers: _buildMarkers(locations, categories, userTrip),
                        polygonOptions: PolygonOptions(
                            borderColor: Colors.blueAccent,
                            color: Colors.black12,
                            borderStrokeWidth: 3),
                        builder: (context, markers) {
                          return FloatingActionButton(
                            heroTag: 'cluster',
                            child: Text(markers.length.toString()),
                            onPressed: null,
                          );
                        },
                      ),
                    ),
                  ]),
              Positioned(
                bottom: 300, // 80 als Abstand vom unteren Rand, anpassbar
                right: 10, // 10 als Abstand vom rechten Rand, anpassbar
                child: Container(
                  height: 40.0, // Gewünschte Höhe
                  width: 40.0, // Gewünschte Breite
                  child: FloatingActionButton(
                    heroTag: 'zoomIn',
                    child: Icon(
                      Icons.zoom_in,
                      size: 18.0,
                    ), // Anpassen der Icon-Größe, wenn nötig
                    onPressed: () {
                      double currentZoom = mapController.zoom!;
                      mapController.move(mapController.center,
                          currentZoom + 0.5); // Zoom in um 0.5
                    },
                    // Die Größe des FloatingActionButton passt sich der Größe des Containers an
                  ),
                ),
              ),
              Positioned(
                bottom: 250, // 10 als Abstand vom unteren Rand
                right: 10, // 10 als Abstand vom rechten Rand
                child: Container(
                  height: 40.0, // Gewünschte Höhe
                  width: 40.0, // Gewünschte Breite
                  child: FloatingActionButton(
                    heroTag: 'zoomOut',
                    child: Icon(
                      Icons.zoom_out,
                      size: 18.0,
                    ), // Anpassen der Icon-Größe, wenn nötig
                    onPressed: () {
                      double currentZoom = mapController.zoom!;
                      mapController.move(mapController.center,
                          currentZoom - 0.5); // Zoom out um 0.5
                    },
                    // Die Größe des FloatingActionButton passt sich der Größe des Containers an
                  ),
                ),
              ),
              Positioned(
                bottom: 200,
                left: 10,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  child: FloatingActionButton(
                    heroTag: 'filterUserTripLocationsButton',
                    child: Icon(Icons.filter_list), // Filter-Icon
                    onPressed: () {
                      setState(() {
                        _filterUserTripLocations =
                            !_filterUserTripLocations;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 250,
                left:
                    10, // Verändert von 'right' zu 'left' um auf der linken Seite zu platzieren
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  child: FloatingActionButton(
                    heroTag: 'categoryButton',
                    child: Icon(Icons.category), // Kategorie-Icon
                    onPressed: () {
                      setState(() {
                        isCategoryWindowOpen = !isCategoryWindowOpen;
                        _categoryWindowVisible = !_categoryWindowVisible;
                      });
                    },
                  ),
                ),
              ),
              if (isCategoryWindowOpen)
                Positioned(
                  bottom: 250 +
                      50, // Positionierung direkt über dem Kategorie-Button
                  left: 10,
                  child: _buildCategoryWindow(),
                ),
            ])),
      );
    });
  }

  // Neues Widget für das Kategorienfenster

  Widget _buildCategoryWindow() {
    return BlocBuilder<AppDataBloc, AppData>(builder: (context, appData) {
      final List<dynamic> categories = appData.categories;
      return AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: _categoryWindowVisible ? 1 : 0,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _categoryWindowVisible = !_categoryWindowVisible;
            });
          },
          child: Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white.withOpacity(0.7),
            ),
            padding: EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: categories.map((category) {
                bool isSelected =
                    _selectedCategories.contains(category['name']);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCategories.remove(category['name']);
                      } else {
                        _selectedCategories.add(category['name']);
                      }
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      category['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }

  List<Marker> _buildMarkers(List locations, List categories, Trip userTrip) {
    return locations.where((location) {
      if (_filterUserTripLocations && !userTrip.tripLocations.contains(location['id'])) {
      return false;
    }
    if (_selectedCategories.isEmpty) {
      return true;
    }
    for (var category in location['categories']) {
      if (_selectedCategories.contains(category)) {
        return true;
      }
    }
      return false;
    }).map((location) {
      String categoryName = location['categories'][0];
      String? categoryImagePath = categories
          .firstWhere((category) => category['name'] == categoryName)['image'];
      bool isTripLocation = userTrip.tripLocations.contains(location['id']);
      bool isSelected = location['id'] == widget.selectedLocationId;
      double markerSize = isSelected ? 30.0 : 30.0;
      Color markerColor;
      if (isSelected) {
        markerColor = Colors.blue;
      } else if (isTripLocation) {
        markerColor = Colors.green;
      } else {
        markerColor = Colors.black87;
      }

      return Marker(
        width: markerSize,
        height: markerSize,
        point: LatLng(
          location['latitude'],
          location['longitude'],
        ),
        builder: (ctx) => GestureDetector(
          onTap: () {
            setState(() {
              widget.selectedLocationId = location['id'];
              widget.selectedLocation = location;
              pminheight = 100;
            });
          },
          child: categoryImagePath != null
              ? Image.asset(categoryImagePath, color: markerColor)
              : const Icon(Icons.error),
        ),
      );
    }).toList();
  }

}
