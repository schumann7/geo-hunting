import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class CompassWidget extends StatelessWidget {
  final double size;

  const CompassWidget({Key? key, this.size = 200}) : super(key: key);

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
                  angle: (direction * (math.pi / 180) * -1),
                  child: Icon(
                    Icons.navigation,
                    size: size * 0.6,
                    color: Colors.red,
                  ),
                ),
                // Texto do grau
                Positioned(
                  bottom: 16,
                  child: Text(
                    '${direction.toStringAsFixed(0)}°',
                    style: const TextStyle(
                      fontSize: 24,
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

