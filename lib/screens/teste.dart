import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_hunting/main.dart';
import 'package:geo_hunting/screens/game_enter_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../components/compass.dart';
import 'dart:core';
import '../components/game_room.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

// Pacote para fazer cards popup
import 'package:flutter_popup_card/flutter_popup_card.dart';

// Pacote para usar gifs
import 'package:gif/gif.dart';

//db
import 'package:geo_hunting/dao/salas_dao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../model/salamodel.dart';

class TesteMapPage extends StatefulWidget {
  final void Function(LatLng)? onMapTap;
  final void Function()? getLocation;
  final bool? create;
  final String? temperature;
  final double? roomLat;
  final double? roomLon;
  final String? roomClue;
  final String? roomName;
  final String? roomId;

  TesteMapPage({
    this.roomLat,
    this.roomLon,
    super.key,
    this.onMapTap,
    this.create,
    this.temperature,
    this.getLocation,
    this.roomClue,
    this.roomName,
    this.roomId,
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
  double currentDistance = -1;
  Stopwatch stopwatch = Stopwatch();

  //Inserir sala no bd local de partidas
  Future<void> _insertNewRoom(room) async {
    await insertRoom(room);
  }

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

  Future<void> _goToCurrentLocation(bool entrou) async {
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
    if (widget.create == true || entrou == true) {
      _mapController.move(_center, 16.0);
    }
    //If para somente mover a camera para centralizar na criação de sala

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
    KeepScreenOn.turnOn();
    await _goToCurrentLocation(true);

    if (currentDistance != 0) {
      showPopupCard(
        context: context,
        builder: (context) {
          return PopupCard(
            elevation: 10,
            color: white,
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
                    Spacer(),
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
      await _goToCurrentLocation(false);

      setState(() {
        currentDistance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          treasure.latitude,
          treasure.longitude,
        );
        if (currentDistance > distance * 0.75) {
          temperature = "Congelando";
        } else if (currentDistance > distance * 0.5) {
          temperature = "Frio";
        } else if (currentDistance > distance * 0.35) {
          temperature = "Neutro";
        } else if (currentDistance > distance * 0.2) {
          temperature = "Morno";
        } else if (currentDistance > distance * 0.1) {
          temperature = "Quente";
        } else {
          temperature = "Fervendo";
        }
        //print("Usuário: " + _center.toString());
      });

      await Future.delayed(const Duration(milliseconds: 25));
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
      temperature = "Parabéns!";
      currentDistance = 0;
      String time =
          "${(((stopwatch.elapsedMilliseconds / 1000).round() / 60).floor()).toString().padLeft(2, '0')}:${((stopwatch.elapsedMilliseconds / 1000).round() % 60).toString().padLeft(2, '0')}";
      String date =
          "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
      final newRoom = RoomHistory(
        id: widget.roomId!,
        name: widget.roomName!,
        distance: walkDistance.toString(),
        time: time,
        date: date,
      );
      _insertNewRoom((newRoom));

      showPopupCard(
        context: context,
        builder: (context) {
          return PopupCard(
            elevation: 10,
            color: white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),

              child: SizedBox(
                width: 220,
                height: 450,
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
                    Image.asset(
                      'assets/tesouro-encontrado.png',
                      width: 220,
                      height: 220,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Durante o percurso, você caminhou $walkDistance metros",
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      "Tesouro encontrado em ${(((stopwatch.elapsedMilliseconds / 1000).round() / 60).floor()).toString().padLeft(2, '0')}:${((stopwatch.elapsedMilliseconds / 1000).round() % 60).toString().padLeft(2, '0')} minutos",
                    ),

                    Spacer(),
                    ElevatedButton(
                      child: Text(
                        "Fechar",
                        style: TextStyle(color: green, fontSize: 20),
                      ),
                      onPressed: () {
                        KeepScreenOn.turnOff();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameEnterPage(),
                          ),
                        );*/
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
                            temperature == "Fervendo"
                                ? Colors.red
                                : (temperature == "Quente"
                                    ? Colors.deepOrange
                                    : (temperature == "Morno"
                                        ? Colors.orange
                                        : (temperature == "Neutro"
                                            ? Colors.amber
                                            : (temperature == "Frio"
                                                ? Colors.lightBlue
                                                : (temperature == "Congelando"
                                                    ? const Color.fromARGB(
                                                      255,
                                                      51,
                                                      64,
                                                      205,
                                                    )
                                                    : green))))),
                      ),
                    ),
                    Text(
                      currentDistance > 0
                          ? "Você está a ${(currentDistance * 100).round() / 100} metros"
                          : "",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                backgroundColor: background,
                centerTitle: true,
                leading:
                    widget.roomClue != null && widget.roomClue != ""
                        ? IconButton(
                          icon: Icon(Icons.lightbulb_outline),
                          onPressed: () {
                            if (widget.roomClue != null &&
                                widget.roomClue != "") {
                              showPopupCard(
                                context: context,
                                builder: (context) {
                                  return PopupCard(
                                    elevation: 10,

                                    color: white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(20),

                                      child: SizedBox(
                                        width: 220,
                                        height: 220,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              textAlign: TextAlign.left,

                                              "Dica:",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            Text(
                                              textAlign: TextAlign.center,
                                              "${widget.roomClue}",
                                            ),
                                            SizedBox(height: 10),

                                            Spacer(),
                                            ElevatedButton(
                                              child: Text(
                                                "Fechar",
                                                style: TextStyle(
                                                  color: green,
                                                  fontSize: 20,
                                                ),
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
                          },
                        )
                        : Text(""),
                actions: [
                  IconButton(
                    onPressed: () {
                      KeepScreenOn.turnOff();
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
                        _goToCurrentLocation(false);
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
                    rotate: true,
                    point: _center,
                    child: Icon(
                      widget.create == true
                          ? Icons.location_pin
                          : Icons.person_pin_circle,
                      color: widget.create == true ? Colors.red : green,
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
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () => _goToCurrentLocation(true),

                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  focusColor: Colors.transparent,
                  focusElevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  shape: CircleBorder(),
                  child: Icon(Icons.my_location, color: green, size: 35),
                ),
              )
              : SizedBox(),
          widget.create != true
              ? Positioned(
                left: 20,
                bottom: 32,
                child: CompassWidget(
                  treasureLat: widget.roomLat!,
                  treasureLon: widget.roomLon!,
                  userLatitude: _center.latitude,
                  userLongitude: _center.longitude,
                  size: 80,
                ),
              )
              : SizedBox(),

          widget.create != true
              ? Positioned(
                right: 32,
                bottom: 32,
                child: FloatingActionButton(
                  onPressed: () async {
                    Position position = await Geolocator.getCurrentPosition();
                    setState(() {
                      _center = LatLng(position.latitude, position.longitude);
                    });
                    _mapController.move(_center, _mapController.camera.zoom);
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  focusColor: Colors.transparent,
                  focusElevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  shape: CircleBorder(),

                  child: Icon(Icons.my_location, color: green, size: 35),
                ),
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
