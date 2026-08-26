import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import '../models/abastecimento.dart';

class GraficoAbastecimentos extends StatefulWidget {
  final List<Abastecimento> abastecimentos;

  const GraficoAbastecimentos({
    super.key,
    required this.abastecimentos,
  });

  @override
  State<GraficoAbastecimentos> createState() =>
      _GraficoAbastecimentosState();
}

class _GraficoAbastecimentosState
    extends State<GraficoAbastecimentos> {
  late String _viewId;

  @override
  void initState() {
    super.initState();

    _viewId =
        'grafico-abastecimentos-${identityHashCode(this)}';

    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.pointerEvents = 'none'
          ..srcdoc = _gerarHtml();

        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.abastecimentos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 400,

      margin: const EdgeInsets.all(16),

      child: HtmlElementView(
        viewType: _viewId,
      ),
    );
  }

  String _gerarHtml() {
    final labels = widget.abastecimentos.map(
      (abastecimento) {
        return '${abastecimento.data} - '
            '${abastecimento.combustivel}';
      },
    ).toList();

    final litros = widget.abastecimentos.map(
      (abastecimento) {
        return abastecimento.litros;
      },
    ).toList();

    final valores = widget.abastecimentos.map(
      (abastecimento) {
        return abastecimento.valorPago;
      },
    ).toList();

    return '''
<!DOCTYPE html>

<html lang="pt-BR">

<head>

<meta charset="UTF-8">

<meta
  name="viewport"
  content="width=device-width, initial-scale=1.0"
>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

html,
body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  font-family: Arial, sans-serif;
  background: #F1E4D1;
}

.container {
  width: 100%;
  height: 100%;
  box-sizing: border-box;
  padding: 10px;
}

canvas {
  width: 100% !important;
  height: 100% !important;
}

</style>

</head>

<body>

<div class="container">

<canvas id="grafico"></canvas>

</div>

<script>

const labels =
  ${_converterParaJavaScript(labels)};

const litros =
  ${_converterParaJavaScript(litros)};

const valores =
  ${_converterParaJavaScript(valores)};

const ctx = document
  .getElementById('grafico')
  .getContext('2d');

new Chart(ctx, {

  type: 'bar',

  data: {

    labels: labels,

    datasets: [

      {
        label: 'Litros',
        data: litros,
        borderWidth: 1,
        backgroundColor: '#B3261E'
      },

      {
        label: 'Valor pago (R\$)',
        data: valores,
        borderWidth: 1,
        backgroundColor: '#D98C7C'
      }

    ]

  },

  options: {

    responsive: true,

    maintainAspectRatio: false,

    plugins: {

      title: {
        display: true,
        text: 'Comparativo dos abastecimentos'
      },

      legend: {
        display: true
      }

    },

    scales: {

      y: {
        beginAtZero: true
      }

    }

  }

});

</script>

</body>

</html>
''';
  }

  String _converterParaJavaScript(dynamic valor) {
    if (valor is List<String>) {
      return '[${valor.map(
        (item) => "'${_escapar(item)}'",
      ).join(',')}]';
    }

    if (valor is List<double>) {
      return '[${valor.join(',')}]';
    }

    return '[]';
  }

  String _escapar(String texto) {
    return texto
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "\\'");
  }
}