import 'package:flutter/material.dart';
import 'package:geo_hunting/screens/game_enter_page.dart';
import 'package:geo_hunting/screens/game_create_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Seja bem-vindo ao',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.w800
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/logo-geo-hunting.png',
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 10),
              const Text(
                'Encontre. Explore. Vença.',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 320,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF185C3C),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                    onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameCreatePage()),
                    );
                    },
                  child: const Text(
                    'Criar Sala',
                    style: TextStyle(fontSize: 24, color: Color(0xFF9FA6A1)),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 320,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF185C3C),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                    onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameEnterPage()),
                    );
                    },
                  child: const Text(
                    'Buscar Sala',
                    style: TextStyle(fontSize: 24, color: Color(0xFF9FA6A1)),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}