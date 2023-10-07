import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallorcaplanner/bloc/trip/trip_bloc.dart';
import 'package:mallorcaplanner/bloc/trip/trip_state.dart';
import 'package:mallorcaplanner/presentation/screens/details_page.dart';
import 'package:mallorcaplanner/use_cases/get_images_of_categories.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripBloc, TripState>(builder: (context, state) {
      if (state is TripLoading) {
        return CircularProgressIndicator();
      } else if (state is TripLoaded) {
        final trip = state.trip;
        final locations = state.locations;
        final categories = state.categories;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${trip.startDate.toLocal().toString().split(' ')[0]} bis ${trip.endDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Divider(),
              if (trip.owner.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Owner',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.owner,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              const Divider(),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Meine Locations', style: TextStyle(fontSize: 24)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: trip.locations.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              location: locations.firstWhere(
                                (entry) => entry.id == trip.locations[index],
                              ),
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
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.asset(
                                      locations
                                          .firstWhere(
                                            (entry) => entry.id == trip.locations[index],
                                          )
                                          .imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 8),
                                        Text(
                                          locations
                                              .firstWhere(
                                                (entry) => entry.id == trip.locations[index],
                                              )
                                              .displayName,
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
                                          locations
                                              .firstWhere(
                                                (entry) => entry.id == trip.locations[index],
                                              )
                                              .address,
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
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
      else {
        return Container();
      }
    });
  }
}
