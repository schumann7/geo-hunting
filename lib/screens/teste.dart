import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_hunting/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../components/compass.dart';

class TesteMapPage extends StatefulWidget {
  final void Function(LatLng)? onMapTap;
  final bool? create;
  final String? temperature;

  const TesteMapPage({super.key, this.onMapTap, this.create, this.temperature});

  @override
  State<TesteMapPage> createState() => _TesteMapPageState();
}

class _TesteMapPageState extends State<TesteMapPage> {
  final MapController _mapController = MapController();
  LatLng _center = LatLng(-27.202456, -52.083215);
  String temperature = "Iniciar";

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_center, 16.0);
  }

  void _onMapTap(TapPosition tapPosition, LatLng latlng) {
    if (widget.create!){
      setState(() {
        _center = latlng;
      });
      if (widget.onMapTap != null) {
        widget.onMapTap!(_center);
      }
    }
  }

  void _inGame() async {
    await _goToCurrentLocation();
    _mapController.move(_center, 16.0);

    LatLng initialPosition = _center;
    LatLng treasure = LatLng(-27.20246,-52.08322); //Configurar pra pegar as coordenadas certo
    LatLng userPosition = initialPosition;
    List<LatLng> path = [initialPosition];
    double walkDistance = 0;

    Future<void> currentPosition() async {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        userPosition = LatLng(position.latitude, position.longitude);
        path.add(userPosition);
      });
    }
    await currentPosition();

    double distance = Geolocator.distanceBetween(initialPosition.latitude, initialPosition.longitude, treasure.latitude, treasure.longitude);

    setState(() {
      temperature = "Frio";
    });

    while(Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, treasure.latitude, treasure.longitude) > 0.01){
      await currentPosition();
      await _goToCurrentLocation();

      setState(() {
        temperature = Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, treasure.latitude, treasure.longitude) > distance*0.5 ? "Frio" : (Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, treasure.latitude, treasure.longitude) < distance*0.1 ? "Quente" : "Morno");
      });

      await Future.delayed(const Duration(seconds: 10));
    }

    for(int i = 1; i < path.length; i++){
      walkDistance += Geolocator.distanceBetween(path[i-1].latitude, path[i-1].longitude, path[i].latitude, path[i].longitude);
    }
    setState(() {
    temperature = "Você caminhou $walkDistance metros";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.create != true? AppBar(
        title: Text(temperature, style: TextStyle(fontWeight: FontWeight.bold,
        color: temperature == "Quente" ? Colors.red : (temperature == "Morno"? Colors.orange : Colors.blue),
        ),),
        backgroundColor: background,
        centerTitle: false,
        leading: SizedBox(),
        actions: [
          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.exit_to_app))
        ],
      ) : null,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _center,
              zoom: 13.0,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.geo_hunting',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80,
                    height: 80,
                    point: _center,
                    child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
          widget.create == true? Positioned(
            right: 16,
            bottom: 32,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: white,
              child: Icon(Icons.my_location, color: green,),
            ),
          ) : Positioned(
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
              onPressed: _inGame,
              backgroundColor: white,
              child: Text(temperature),
          )),
          widget.create != true? Positioned(
            left: 16,
            bottom: 32,
            child: CompassWidget(size: 80),
          ): SizedBox(),
        ],
      ),
    );
  }
}

