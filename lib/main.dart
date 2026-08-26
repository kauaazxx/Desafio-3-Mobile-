import 'package:flutter/material.dart';

import 'telas/splash.dart';

void main() {
  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatefulWidget {
  const MeuAplicativo({super.key});

  @override
  State<MeuAplicativo> createState() => _MeuAplicativoState();
}

class _MeuAplicativoState extends State<MeuAplicativo> {
  bool temaEscuro = false;

  void trocarTema() {
    setState(() {
      temaEscuro = !temaEscuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Abastecimento de Veículos',

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 75, 208, 14),
        ),

        scaffoldBackgroundColor: const Color(0xFFF1E4D1),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 104, 209, 18),
          brightness: Brightness.dark,
        ),
      ),

      themeMode: temaEscuro
          ? ThemeMode.dark
          : ThemeMode.light,

      home: Splash(
        temaEscuro: temaEscuro,
        trocarTema: trocarTema,
      ),
    );
  }
}