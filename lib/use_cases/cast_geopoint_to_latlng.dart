import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

LatLng castGeoPointToLatLng(GeoPoint? geoPoint) {
  if (geoPoint != null) {
    return LatLng(geoPoint.latitude, geoPoint.longitude);
  }
  // Sie können hier einen Standardwert zurückgeben oder einen Fehler werfen, je nach Bedarf
  throw ArgumentError("GeoPoint darf nicht null sein");
}