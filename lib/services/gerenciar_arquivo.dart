import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/abastecimento.dart';

abstract class GerenciarArquivo {
  static Future<String> get _caminhoLocal async {
    final diretorio = await getApplicationDocumentsDirectory();

    return diretorio.path;
  }

  static Future<File> get _arquivoLocal async {
    final caminho = await _caminhoLocal;

    return File('$caminho/abastecimentos.json');
  }

  static Future<void> salvar(
    List<Abastecimento> abastecimentos,
  ) async {
    final arquivo = await _arquivoLocal;

    final lista = abastecimentos.map((abastecimento) {
      return abastecimento.toMap();
    }).toList();

    final texto = jsonEncode(lista);

    await arquivo.writeAsString(texto);
  }

  static Future<List<Abastecimento>> abrir() async {
    try {
      final arquivo = await _arquivoLocal;

      if (!await arquivo.exists()) {
        return [];
      }

      final texto = await arquivo.readAsString();

      if (texto.isEmpty) {
        return [];
      }

      final lista = jsonDecode(texto);

      return List<Abastecimento>.from(
        lista.map((item) {
          return Abastecimento.fromMap(item);
        }),
      );
    } catch (e) {
      return [];
    }
  }
}