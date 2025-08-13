import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

import 'package:geo_hunting/main.dart';

class CompassWidget extends StatelessWidget {
  final double size;
  final double treasureLat;
  final double treasureLon;
  final double userLatitude;
  final double userLongitude;

  const CompassWidget({
    super.key,
    this.size = 200,
    required this.treasureLat,
    required this.treasureLon,
    required this.userLatitude,
    required this.userLongitude,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao acessar a bússola'));
        }
        double? direction = snapshot.data?.heading;
        if (direction == null) {
          return const Center(child: Text('Bússola não disponível'));
        }
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Círculo da bússola
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: green, width: 3),
                  ),
                ),
                // Ponteiro
                Transform.rotate(
                  // Calculate the bearing to the target coordinate and rotate the pointer accordingly.
                  angle:
                      (() {
                        // Replace these with your target latitude and longitude
                        double targetLat = treasureLat;
                        double targetLng = treasureLon;

                        // Replace these with the user's current latitude and longitude
                        // You need to get the user's location using a location package
                        double userLat = userLatitude;
                        double userLng = userLongitude;
                        /*print(
                          "Bússola Usuário: " +
                              userLat.toString() +
                              ", " +
                              userLng.toString(),
                        );   */

                        double toRadians(double degree) =>
                            degree * (math.pi / 180);

                        double bearing(
                          double lat1,
                          double lon1,
                          double lat2,
                          double lon2,
                        ) {
                          final dLon = toRadians(lon2 - lon1);
                          final y = math.sin(dLon) * math.cos(toRadians(lat2));
                          final x =
                              math.cos(toRadians(lat1)) *
                                  math.sin(toRadians(lat2)) -
                              math.sin(toRadians(lat1)) *
                                  math.cos(toRadians(lat2)) *
                                  math.cos(dLon);
                          final brng = math.atan2(y, x);
                          return (brng * 180 / math.pi + 360) % 360;
                        }

                        final targetBearing = bearing(
                          userLat,
                          userLng,
                          targetLat,
                          targetLng,
                        );

                        // The angle to rotate is the difference between the compass heading and the bearing
                        return ((targetBearing - direction) * (math.pi / 180));
                      })(),
                  child: Icon(
                    Icons.navigation,
                    size: size * 0.5,
                    color: const Color.fromARGB(255, 40, 176, 58),
                  ),
                ),
                // Texto do grau
                Positioned(
                  bottom: 2,

                  child: Text(
                    ' ${direction.toStringAsFixed(0)}°',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
