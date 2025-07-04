import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geodesy/geodesy.dart' as geo;

LatLng posicao = LatLng(-27.2, -52.08);


final geodesy = geo.Geodesy();

class Mapa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> _markers = {};

  @override
void initState() {
  super.initState();

  _markers.add(
    Marker(
      markerId: MarkerId("ponto1"),
      position: LatLng(-27.2022110825024, -52.08320584850461),
      infoWindow: InfoWindow(
        title: "Mas que lugar bonito",
        snippet: "Mussum Ipsum, cacilds vidis litro abertis. Mauris nec dolor in eros commodo tempor.",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ),
  );

  _markers.add(
    Marker(
      markerId: MarkerId("ponto2"),
      position: LatLng(-27.205303, -52.084170),
      infoWindow: InfoWindow(
        title: "Mas um lugar bonito",
        snippet: "Mussum Ipsum, cacilds vidis litro abertis. Mauris nec dolor in eros commodo tempor.",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ),
  );

}

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-27.2022110825024, -52.08320584850461),
    zoom: 19.151926040649414,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-27.205303, -52.084170),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
      dynamic distance = geodesy.distanceBetweenTwoGeoPoints(geo.LatLng(-27.205303, -52.084170), geo.LatLng(-27.2022110825024, -52.08320584850461));

  Set<Polyline> polylines = {Polyline(
    polylineId: PolylineId("rota1"),
    points: [LatLng(-27.205303, -52.084170), LatLng(-27.2022110825024, -52.08320584850461)],
    color: Colors.green,
    width: 7,
  )};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        polylines: polylines,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text("To the $distance!"),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}