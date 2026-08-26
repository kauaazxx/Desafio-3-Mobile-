class Abastecimento {
  String data;
  String combustivel;
  double litros;
  double valorPago;
  double quilometragem;

  Abastecimento({
    required this.data,
    required this.combustivel,
    required this.litros,
    required this.valorPago,
    required this.quilometragem,
  });

  double get precoPorLitro {
    if (litros == 0) {
      return 0;
    }

    return valorPago / litros;
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'combustivel': combustivel,
      'litros': litros,
      'valorPago': valorPago,
      'quilometragem': quilometragem,
    };
  }

  factory Abastecimento.fromMap(Map<String, dynamic> mapa) {
    return Abastecimento(
      data: mapa['data'],
      combustivel: mapa['combustivel'],
      litros: (mapa['litros'] as num).toDouble(),
      valorPago: (mapa['valorPago'] as num).toDouble(),
      quilometragem: (mapa['quilometragem'] as num).toDouble(),
    );
  }
}