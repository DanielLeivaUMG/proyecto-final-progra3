class RelacionesDanioTipo {
  const RelacionesDanioTipo({
    required this.tipo,
    required this.nombreMostrado,
    this.sinDanioDe = const <String>[],
    this.medioDanioDe = const <String>[],
    this.dobleDanioDe = const <String>[],
  });

  final String tipo;
  final String nombreMostrado;
  final List<String> sinDanioDe;
  final List<String> medioDanioDe;
  final List<String> dobleDanioDe;
}
