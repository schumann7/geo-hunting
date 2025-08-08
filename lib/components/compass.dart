import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class CompassWidget extends StatelessWidget {
  final double size;
  final double treasureLat;
  final double treasureLon;

  const CompassWidget({
    Key? key,
    this.size = 200,
    required this.treasureLat,
    required this.treasureLon,
  }) : super(key: key);

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
          child: Container(
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
                    border: Border.all(color: Colors.grey, width: 4),
                  ),
                ),
                // Ponteiro
                Transform.rotate(
                  // Calculate the bearing to the target coordinate and rotate the pointer accordingly.
                  angle:
                      (() {
                        // Replace these with your target latitude and longitude
                        double targetLat =
                            treasureLat; // Example: San Francisco
                        double targetLng = treasureLon;

                        // Replace these with the user's current latitude and longitude
                        // You need to get the user's location using a location package
                        const double userLat = 0.0;
                        const double userLng = 0.0;

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
                    color: Colors.red,
                  ),
                ),
                // Texto do grau
                Positioned(
                  bottom: 2,

                  // Botei uns espaços antes do texto pq não parecia centralizado (pq tem a bolinha do grau)
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
