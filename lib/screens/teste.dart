import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_hunting/main.dart';
import 'package:geo_hunting/screens/game_enter_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../components/compass.dart';
import 'dart:core';

import '../components/game_room.dart';

// Pacote para fazer cards popup
import 'package:flutter_popup_card/flutter_popup_card.dart';

// Pacote para usar gifs
import 'package:gif/gif.dart';

class TesteMapPage extends StatefulWidget {
  final void Function(LatLng)? onMapTap;
  final void Function()? getLocation;
  final bool? create;
  final String? temperature;
  final double? roomLat;
  final double? roomLon;

  TesteMapPage({
    this.roomLat,
    this.roomLon,
    super.key,
    this.onMapTap,
    this.create,
    this.temperature,
    this.getLocation,
  });

  @override
  State<TesteMapPage> createState() => _TesteMapPageState();
}

// TickerProviderStateMixin para poder usar as gifs
class _TesteMapPageState extends State<TesteMapPage>
    with TickerProviderStateMixin {
  late GifController _controllerGif;
  final MapController _mapController = MapController();
  LatLng _center = LatLng(-27.202456, -52.083215);
  String temperature = "Aguarde...";
  double currentDistance = 0;
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _controllerGif = GifController(vsync: this);
  }

  @override
  void dispose() {
    _controllerGif.dispose();
    super.dispose();
  }

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

    if (widget.getLocation != null) {
      widget.getLocation!();
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng latlng) {
    if (widget.create!) {
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

    print("Widget Room Lat: " + widget.roomLat.toString());

    if (currentDistance != 0) {
      showPopupCard(
        context: context,
        builder: (context) {
          return PopupCard(
            elevation: 10,
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),

              child: SizedBox(
                width: 220,
                height: 426,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Calibre o dispositivo para jogar!",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Para calibrar a bússola do seu celular, você precisará realizar movimentos circulares com o aparelho.",
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return GestureDetector(
                          onTap: () {},
                          child: Gif(
                            image: AssetImage("assets/gifcalibrar.gif"),
                            controller: _controllerGif,
                            autostart: Autostart.loop,
                            placeholder: (context) => const Text('Loading...'),
                            onFetchCompleted: () {
                              _controllerGif.reset();
                              _controllerGif.forward();
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text(
                        "Fechar",
                        style: TextStyle(color: green, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    LatLng initialPosition = _center;
    LatLng treasure = LatLng(
      widget.roomLat!,
      widget.roomLon!,
    ); //Configurar pra pegar as coordenadas certo
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

    double distance = Geolocator.distanceBetween(
      initialPosition.latitude,
      initialPosition.longitude,
      treasure.latitude,
      treasure.longitude,
    );

    setState(() {
      temperature = "Frio";
    });

    stopwatch.start();

    while (Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          treasure.latitude,
          treasure.longitude,
        ) >
        5) {
      await currentPosition();
      await _goToCurrentLocation();

      setState(() {
        currentDistance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          treasure.latitude,
          treasure.longitude,
        );
        if (currentDistance > distance * 0.75) {
          temperature = "Frio";
        } else if (currentDistance > distance * 0.5) {
          temperature = "Gélido";
        } else if (currentDistance > distance * 0.35) {
          temperature = "Fresco";
        } else if (currentDistance > distance * 0.2) {
          temperature = "Morno";
        } else if (currentDistance > distance * 0.1) {
          temperature = "Quente";
        } else {
          temperature = "Fervendo";
        }
      });

      await Future.delayed(const Duration(milliseconds: 50));
    }

    stopwatch.stop();

    for (int i = 1; i < path.length; i++) {
      walkDistance += Geolocator.distanceBetween(
        path[i - 1].latitude,
        path[i - 1].longitude,
        path[i].latitude,
        path[i].longitude,
      );
      walkDistance = (walkDistance * 100).round() / 100;
    }
    setState(() {
      temperature = "Você andou $walkDistance metros";
      currentDistance = 0;
      showPopupCard(
        context: context,
        builder: (context) {
          return PopupCard(
            elevation: 10,
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),

              child: SizedBox(
                width: 220,
                height: 426,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Parabéns! Você encontrou o tesouro.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Durante sua jornada, você caminhou um total de $walkDistance metros.",
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tesouro encontrado em ${(((stopwatch.elapsedMilliseconds / 1000).round() / 60).floor()).toString().padLeft(2, '0')}:${((stopwatch.elapsedMilliseconds / 1000).round() % 60).toString().padLeft(2, '0')} minutos",
                    ),

                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text(
                        "Fechar",
                        style: TextStyle(color: green, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.create != true
              ? AppBar(
                title: Column(
                  children: [
                    Text(
                      temperature,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            temperature == "Quente" || temperature == "Fervendo"
                                ? Colors.red
                                : (temperature == "Morno" ||
                                        temperature == "Fresco"
                                    ? Colors.orange
                                    : (temperature == "Gélido" ||
                                            temperature == "Frio"
                                        ? Colors.blue
                                        : green)),
                      ),
                    ),
                    Text(
                      currentDistance != 0
                          ? "Você está a ${(currentDistance * 100).round() / 100} metros"
                          : "Tesouro encontrado em ${(((stopwatch.elapsedMilliseconds / 1000).round() / 60).floor()).toString().padLeft(2, '0')}:${((stopwatch.elapsedMilliseconds / 1000).round() % 60).toString().padLeft(2, '0')} minutos",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                backgroundColor: background,
                centerTitle: true,
                leading: SizedBox(),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.exit_to_app),
                  ),
                ],
              )
              : null,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _center,
              zoom: 13.0,
              onTap: _onMapTap,
              onMapReady:
                  widget.create == true
                      ? () {
                        _goToCurrentLocation();
                      }
                      : _inGame,
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
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.create == true
              ? Positioned(
                right: 16,
                bottom: 32,
                child: FloatingActionButton(
                  onPressed: _goToCurrentLocation,
                  backgroundColor: white,
                  child: Icon(Icons.my_location, color: green),
                ),
              )
              : SizedBox(),
          widget.create != true
              ? Positioned(left: 16, bottom: 32, child: CompassWidget(size: 80))
              : SizedBox(),
        ],
      ),
    );
  }
}
