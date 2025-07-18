import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_hunting/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../components/compass.dart';
import 'dart:core';

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
  String temperature = "Aguarde...";
  double currentDistance = 0;
  Stopwatch stopwatch = Stopwatch();

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
    LatLng initialPosition = _center;
    LatLng treasure = LatLng(-27.2052625, -52.0840469); //Configurar pra pegar as coordenadas certo
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

    stopwatch.start();

    while(Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, treasure.latitude, treasure.longitude) > 5){
      await currentPosition();
      await _goToCurrentLocation();

      setState(() {
        currentDistance = Geolocator.distanceBetween(userPosition.latitude, userPosition.longitude, treasure.latitude, treasure.longitude);
        if(currentDistance > distance*0.75){
          temperature = "Frio";
        } else if (currentDistance > distance*0.5){
        temperature = "Gélido";
        } else if (currentDistance > distance*0.35){
          temperature = "Fresco";
        } else if (currentDistance > distance*0.2){
          temperature = "Morno";
        } else if (currentDistance > distance*0.1){
          temperature = "Quente";
        } else {
          temperature = "Fervendo";
        }
      });

      await Future.delayed(const Duration(seconds: 3));
    }

    stopwatch.stop();

    for(int i = 1; i < path.length; i++){
      walkDistance += Geolocator.distanceBetween(path[i-1].latitude, path[i-1].longitude, path[i].latitude, path[i].longitude);
      walkDistance = (walkDistance*100).round()/100;
    }
    setState(() {
    temperature = "Você andou $walkDistance metros";
    currentDistance = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _goToCurrentLocation();
    // _mapController.move(_center, 16.0);
    return Scaffold(
      appBar: widget.create != true? AppBar(
        title: Column(
          children: [
            Text(temperature, style: TextStyle(fontWeight: FontWeight.bold,
            color: temperature == "Quente" || temperature == "Fervendo" ? Colors.red : (temperature == "Morno" || temperature == "Fresco" ? Colors.orange : (temperature == "Gélido" || temperature == "Frio" ? Colors.blue : green)),
            ),),
            Text(currentDistance != 0? "Você está a ${(currentDistance*100).round()/100} metros" : "Tesouro encontrado em ${(((stopwatch.elapsedMilliseconds/1000).round()/60).floor()).toString().padLeft(2, '0')}:${((stopwatch.elapsedMilliseconds/1000).round()%60).toString().padLeft(2, '0')} minutos", style: TextStyle(fontSize: 15),),
          ],
        ),
        backgroundColor: background,
        centerTitle: true,
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
              onMapReady: _inGame,
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
          ) : SizedBox(),
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

