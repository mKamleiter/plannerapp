import 'package:flutter/material.dart';
import 'package:mallorcaplanner/bloc/details/details_bloc.dart';
import 'package:mallorcaplanner/bloc/details/details_event.dart';
import 'package:mallorcaplanner/bloc/details/details_state.dart';
import 'package:mallorcaplanner/entities/location.dart';
import 'package:mallorcaplanner/presentation/screens/details_images.dart';
import 'package:mallorcaplanner/presentation/screens/details_info_tab.dart';
import 'package:mallorcaplanner/presentation/screens/map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsPage extends StatefulWidget {
  final Location location;

  DetailsPage({required this.location});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailsBloc>().add(LoadDetailsEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(builder: (context, state) {
      if (state is DetailsLoading) {
        return const CircularProgressIndicator();
      } else if (state is DetailsLoaded) {
        return DefaultTabController(
          length: 2, // Anzahl der Tabs
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.location.displayName),
              bottom: TabBar(
                tabs: [
                  Tab(text: "Info"),
                  Tab(text: "Bilder"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                DetailsInfo(location: widget.location),
                DetailsImages(location: widget.location),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }


}
