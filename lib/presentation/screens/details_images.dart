import 'package:flutter/material.dart';
import 'package:mallorcaplanner/entities/location.dart';

class DetailsImages extends StatefulWidget {
  final Location location;

  DetailsImages({required this.location});

  @override
  _DetailsImagesState createState() => _DetailsImagesState();
}

class _DetailsImagesState extends State<DetailsImages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hier kommen die Bilder hin'),
    );
  }
}
