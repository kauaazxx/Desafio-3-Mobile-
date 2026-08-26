import 'package:flutter/material.dart';

import '../models/abastecimento.dart';
import '../services/gerenciar_arquivo.dart';
import 'grafico_abastecimentos.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Abastecimento> abastecimentos = [];

  @override
  void initState() {
    super.initState();

    carregarAbastecimentos();
  }

  Future<void> carregarAbastecimentos() async {
    final lista = await GerenciarArquivo.abrir();

    setState(() {
      abastecimentos = lista;
    });
  }

  Future<void> salvarAbastecimentos() async {
    await GerenciarArquivo.salvar(abastecimentos);
  }

  void adicionarAbastecimento() {
    mostrarFormulario();
  }

  void editarAbastecimento(int indice) {
    mostrarFormulario(
      abastecimento: abastecimentos[indice],
      indice: indice,
    );
  }

  Future<void> excluirAbastecimento(int indice) async {
    setState(() {
      abastecimentos.removeAt(indice);
    });

    await salvarAbastecimentos();
  }

  double calcularPrecoMedio() {
    if (abastecimentos.isEmpty) {
      return 0;
    }

    double totalValor = 0;
    double totalLitros = 0;

    for (final abastecimento in abastecimentos) {
      totalValor += abastecimento.valorPago;
      totalLitros += abastecimento.litros;
    }

    if (totalLitros == 0) {
      return 0;
    }

    return totalValor / totalLitros;
  }

  double calcularConsumoMedio() {
    if (abastecimentos.length < 2) {
      return 0;
    }

    final lista = List<Abastecimento>.from(abastecimentos);

    lista.sort(
      (a, b) => a.quilometragem.compareTo(b.quilometragem),
    );

    double totalConsumo = 0;
    int quantidade = 0;

    for (int i = 1; i < lista.length; i++) {
      final diferencaKm =
          lista[i].quilometragem -
          lista[i - 1].quilometragem;

      if (diferencaKm > 0 && lista[i].litros > 0) {
        final consumo = diferencaKm / lista[i].litros;

        totalConsumo += consumo;
        quantidade++;
      }
    }

    if (quantidade == 0) {
      return 0;
    }

    return totalConsumo / quantidade;
  }

  void mostrarFormulario({
    Abastecimento? abastecimento,
    int? indice,
  }) {
    final dataController = TextEditingController(
      text: abastecimento?.data ?? '',
    );

    final litrosController = TextEditingController(
      text: abastecimento?.litros.toString() ?? '',
    );

    final valorController = TextEditingController(
      text: abastecimento?.valorPago.toString() ?? '',
    );

    final quilometragemController = TextEditingController(
      text: abastecimento?.quilometragem.toString() ?? '',
    );

    String combustivelSelecionado =
        abastecimento?.combustivel ?? 'Gasolina';

    showDialog(
      context: context,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                abastecimento == null
                    ? 'Novo abastecimento'
                    : 'Editar abastecimento',
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    TextField(
                      controller: dataController,

                      decoration: const InputDecoration(
                        labelText: 'Data',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: combustivelSelecionado,

                      decoration: const InputDecoration(
                        labelText: 'Combustível',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.local_gas_station,
                        ),
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: 'Gasolina',
                          child: Text('Gasolina'),
                        ),
                        DropdownMenuItem(
                          value: 'Etanol',
                          child: Text('Etanol'),
                        ),
                        DropdownMenuItem(
                          value: 'Diesel',
                          child: Text('Diesel'),
                        ),
                        DropdownMenuItem(
                          value: 'GNV',
                          child: Text('GNV'),
                        ),
                      ],

                      onChanged: (valor) {
                        if (valor != null) {
                          setDialogState(() {
                            combustivelSelecionado = valor;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: litrosController,

                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      decoration: const InputDecoration(
                        labelText: 'Litros',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.water_drop),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: valorController,

                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      decoration: const InputDecoration(
                        labelText: 'Valor pago (R\$)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: quilometragemController,

                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      decoration: const InputDecoration(
                        labelText: 'Quilometragem (km)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.speed),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text('Cancelar'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final data =
                        dataController.text.trim();

                    final litros = double.tryParse(
                      litrosController.text.replaceAll(
                        ',',
                        '.',
                      ),
                    );

                    final valorPago = double.tryParse(
                      valorController.text.replaceAll(
                        ',',
                        '.',
                      ),
                    );

                    final quilometragem =
                        double.tryParse(
                      quilometragemController.text
                          .replaceAll(',', '.'),
                    );

                    if (data.isEmpty ||
                        litros == null ||
                        valorPago == null ||
                        quilometragem == null ||
                        litros <= 0 ||
                        valorPago < 0 ||
                        quilometragem < 0) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha todos os campos corretamente.',
                          ),
                        ),
                      );

                      return;
                    }

                    final novoAbastecimento =
                        Abastecimento(
                      data: data,
                      combustivel:
                          combustivelSelecionado,
                      litros: litros,
                      valorPago: valorPago,
                      quilometragem: quilometragem,
                    );

                    setState(() {
                      if (indice == null) {
                        abastecimentos
                            .add(novoAbastecimento);
                      } else {
                        abastecimentos[indice] =
                            novoAbastecimento;
                      }
                    });

                    await salvarAbastecimentos();

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },

                  child: Text(
                    abastecimento == null
                        ? 'Adicionar'
                        : 'Salvar',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final precoMedio = calcularPrecoMedio();
    final consumoMedio = calcularConsumoMedio();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Abastecimentos',
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 32,

            onPressed: adicionarAbastecimento,
          ),
        ],
      ),

      body: abastecimentos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum abastecimento cadastrado.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),

                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: const Color(0xFFE3F2FD),

                          child: Padding(
                            padding: const EdgeInsets.all(16),

                            child: Column(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: Color(0xFF0D47A1),
                                  size: 30,
                                ),

                                const SizedBox(height: 8),

                                const Text(
                                  'Preço médio',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  'R\$ ${precoMedio.toStringAsFixed(2)}/L',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Card(
                          color: const Color(0xFFE3F2FD),

                          child: Padding(
                            padding: const EdgeInsets.all(16),

                            child: Column(
                              children: [
                                const Icon(
                                  Icons.speed,
                                  color: Color(0xFF0D47A1),
                                  size: 30,
                                ),

                                const SizedBox(height: 8),

                                const Text(
                                  'Consumo médio',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  consumoMedio == 0
                                      ? '--'
                                      : '${consumoMedio.toStringAsFixed(2)} km/L',

                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ...List.generate(
                  abastecimentos.length,
                  (index) {
                    final abastecimento =
                        abastecimentos[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),

                      color: const Color(0xFFE3F2FD),

                      child: ListTile(
                        onTap: () {
                          editarAbastecimento(index);
                        },

                        leading: const CircleAvatar(
                          backgroundColor:
                              Color(0xFF0D47A1),

                          child: Icon(
                            Icons.local_gas_station,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          abastecimento.combustivel,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          '${abastecimento.data}\n'
                          '${abastecimento.litros.toStringAsFixed(1)} L'
                          ' • '
                          'R\$ ${abastecimento.valorPago.toStringAsFixed(2)}'
                          ' • '
                          '${abastecimento.quilometragem.toStringAsFixed(0)} km',
                        ),

                        isThreeLine: true,

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),

                          color:
                              const Color(0xFF0D47A1),

                          iconSize: 28,

                          onPressed: () {
                            excluirAbastecimento(
                              index,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                const Divider(),

                const Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 16,
                    right: 16,
                  ),

                  child: Text(
                    'Comparativo dos abastecimentos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                GraficoAbastecimentos(
                  abastecimentos: abastecimentos,
                ),

                const SizedBox(height: 20),
              ],
            ),
    );
  }
}