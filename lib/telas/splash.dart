import 'package:flutter/material.dart';

import 'home.dart';

class Splash extends StatelessWidget {
  final bool temaEscuro;
  final VoidCallback trocarTema;

  const Splash({
    super.key,
    required this.temaEscuro,
    required this.trocarTema,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: temaEscuro
          ? null
          : const Color(0xFFF1E4D1),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                color: const Color(0xFFB3261E),
                borderRadius: BorderRadius.circular(30),
              ),

              child: const Icon(
                Icons.local_gas_station,
                color: Colors.white,
                size: 60,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Abastecimento',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Controle seus abastecimentos',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 35),

            ElevatedButton.icon(
              onPressed: trocarTema,

              icon: Icon(
                temaEscuro
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),

              label: Text(
                temaEscuro
                    ? 'Tema claro'
                    : 'Tema escuro',
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: 200,
              height: 50,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB3261E),
                  foregroundColor: Colors.white,
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },

                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}