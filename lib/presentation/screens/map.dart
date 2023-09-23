import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:mallorcaplanner/bloc/map_bloc/map_event.dart';
import 'package:mallorcaplanner/bloc/map_bloc/map_state.dart';
import 'package:mallorcaplanner/bottom_bar.dart';
import 'package:mallorcaplanner/entities/category.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/entities/trip.dart';
import 'package:mallorcaplanner/presentation/widgets/category_window.dart';
import 'package:mallorcaplanner/presentation/widgets/info_panel.dart';
import 'package:mallorcaplanner/presentation/widgets/location_marker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../bloc/map_bloc/map_bloc.dart';

class LocationsMap extends StatefulWidget {
  String? selectedLocationId;
  LatLng? center;
  double? zoomLevel;
  Location? selectedLocation;
  LocationsMap({
    this.selectedLocationId,
    this.center,
    this.zoomLevel,
    this.selectedLocation,
  });

  @override
  _LocationsMapState createState() => _LocationsMapState();
}

class _LocationsMapState extends State<LocationsMap> {
  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(LoadAllLocationsEvent());
    context.read<MapBloc>().add(LoadTripByCurrentUser());
  }

  var mapController = MapController();
  final int _currentIndex = 2;
  bool isCategoryWindowOpen = false;
  Set<Category> _selectedCategories = {};
  bool _categoryWindowVisible = false;
  bool _filterUserTripLocations = false;

  Location? selectedLocation;
  bool infoPanelEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      if (state is MapLoading) {
        return Scaffold(
            bottomNavigationBar: CustomBottomBar(currentIndex: _currentIndex),
            body: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: widget.center ?? LatLng(39.5153, 2.7471),
                  zoom: widget.zoomLevel ?? 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://api.mapbox.com/styles/v1/mkamleiter/clltqs61w00b601nzc36eg8ib/draft/tiles/{z}/{x}/{y}?access_token=sk.eyJ1IjoibWthbWxlaXRlciIsImEiOiJjbGx3dXNydDcwMzJmM2RwZzBpcG1rczBiIn0.r4F5JI-jpyoibpWvkfAj-Q",
                  ),
                ]));
      } else if (state is MapLoaded) {
        final locations = state.locations;
        final categories = state.categories;
        final trip = state.trip;
        return Scaffold(
          bottomNavigationBar: CustomBottomBar(currentIndex: _currentIndex),
          body: SlidingUpPanel(
              minHeight: (infoPanelEnabled) ? 80 : 0,
              maxHeight: MediaQuery.of(context).size.height / 2,
              panel: InfoPanelContent(selectedLocation: selectedLocation),
              body: Stack(children: [
                FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: widget.center ?? LatLng(39.5153, 2.7471),
                      zoom: widget.zoomLevel ?? 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://api.mapbox.com/styles/v1/mkamleiter/clltqs61w00b601nzc36eg8ib/draft/tiles/{z}/{x}/{y}?access_token=sk.eyJ1IjoibWthbWxlaXRlciIsImEiOiJjbGx3dXNydDcwMzJmM2RwZzBpcG1rczBiIn0.r4F5JI-jpyoibpWvkfAj-Q",
                      ),
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 120,
                          size: const Size(40, 40),
                          fitBoundsOptions: const FitBoundsOptions(
                            padding: EdgeInsets.all(50),
                          ),
                          markers: buildMarkers(locations, categories, trip),
                          polygonOptions: const PolygonOptions(borderColor: Colors.blueAccent, color: Colors.black12, borderStrokeWidth: 3),
                          builder: (context, markers) {
                            return FloatingActionButton(
                              heroTag: 'cluster',
                              onPressed: null,
                              child: Text(markers.length.toString()),
                            );
                          },
                        ),
                      ),
                    ]),
                Positioned(
                  bottom: 300, // 80 als Abstand vom unteren Rand, anpassbar
                  right: 10, // 10 als Abstand vom rechten Rand, anpassbar
                  child: SizedBox(
                    height: 40.0, // Gewünschte Höhe
                    width: 40.0, // Gewünschte Breite
                    child: FloatingActionButton(
                      heroTag: 'zoomIn',
                      child: const Icon(
                        Icons.zoom_in,
                        size: 18.0,
                      ), // Anpassen der Icon-Größe, wenn nötig
                      onPressed: () {
                        double currentZoom = mapController.zoom;
                        mapController.move(mapController.center, currentZoom + 0.5); // Zoom in um 0.5
                      },
                      // Die Größe des FloatingActionButton passt sich der Größe des Containers an
                    ),
                  ),
                ),
                Positioned(
                  bottom: 250, // 10 als Abstand vom unteren Rand
                  right: 10, // 10 als Abstand vom rechten Rand
                  child: SizedBox(
                    height: 40.0, // Gewünschte Höhe
                    width: 40.0, // Gewünschte Breite
                    child: FloatingActionButton(
                      heroTag: 'zoomOut',
                      child: const Icon(
                        Icons.zoom_out,
                        size: 18.0,
                      ), // Anpassen der Icon-Größe, wenn nötig
                      onPressed: () {
                        double currentZoom = mapController.zoom;
                        mapController.move(mapController.center, currentZoom - 0.5); // Zoom out um 0.5
                      },
                      // Die Größe des FloatingActionButton passt sich der Größe des Containers an
                    ),
                  ),
                ),
                Positioned(
                  bottom: 200,
                  left: 10,
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: FloatingActionButton(
                      heroTag: 'filterUserTripLocationsButton',
                      child: const Icon(Icons.filter_list), // Filter-Icon
                      onPressed: () {
                        setState(() {
                          _filterUserTripLocations = !_filterUserTripLocations;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 250,
                  left: 10, // Verändert von 'right' zu 'left' um auf der linken Seite zu platzieren
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: FloatingActionButton(
                      heroTag: 'categoryButton',
                      child: const Icon(Icons.category), // Kategorie-Icon
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
                    bottom: 250 + 50, // Positionierung direkt über dem Kategorie-Button
                    left: 10,
                    child: CategoryWindow(
                        categories: categories,
                        selectedCategories: _selectedCategories,
                        onCategorySelectionChanged: (newSelection) {
                          setState(() {
                            _selectedCategories = newSelection;
                          });
                        }),
                  ),
              ])),
        );
      } else {
        return Container();
      }
    });
  }

  List<Marker> buildMarkers(List<Location> locations, List<Category> categories, Trip trip) {
    Set<String> selectedCategoryNames = _selectedCategories.map((category) => category.name).toSet();
    var filteredLocations = locations.where((location) {
      if (_filterUserTripLocations && !trip.locations.contains(location.id)) {
        return false;
      }
      if (location.categories.any(selectedCategoryNames.contains)) {
        return true;
      } else if (selectedCategoryNames.isEmpty) {
        return true;
      }
      return false;
    }).toList();
    return filteredLocations.map((location) {
      String categoryName = location.categories[0];
      String? categoryImagePath = categories.firstWhere((category) => category.name == categoryName).imageUrl;
      bool isSelected;
      bool isInTrip = false;
      if (selectedLocation != null) {
        isSelected = location.id == (selectedLocation)!.id;
      } else {
        isSelected = false;
      }

      if (trip.locations.contains(location.id)) {
        isInTrip = true;
      }
      return LocationMarker(
        location: location,
        categoryImagePath: categoryImagePath,
        isSelected: isSelected,
        isInTrip: isInTrip,
        onTap: () {
          setState(() {
            selectedLocation = location;
            infoPanelEnabled = true;
          });
        },
      ).build();
    }).toList();
  }
}
