class RelacionesDanioTipo {
  const RelacionesDanioTipo({
    required this.tipo,
    this.sinDanioDe = const <String>[],
    this.medioDanioDe = const <String>[],
    this.dobleDanioDe = const <String>[],
  });

  final String tipo;
  final List<String> sinDanioDe;
  final List<String> medioDanioDe;
  final List<String> dobleDanioDe;
}
