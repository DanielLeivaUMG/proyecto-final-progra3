class RelacionesDanioTipo {
  const RelacionesDanioTipo({
    required this.tipo,
    required this.nombreMostrado,
    this.idTipo,
    this.sinDanioDe = const <String>[],
    this.medioDanioDe = const <String>[],
    this.dobleDanioDe = const <String>[],
  });

  final String tipo;
  final String nombreMostrado;
  final int? idTipo;
  final List<String> sinDanioDe;
  final List<String> medioDanioDe;
  final List<String> dobleDanioDe;
}
