class Pokemon {
  final String nombre;
  final String url;
  final int? id;
  final List<String> tipos;

  const Pokemon({
    required this.nombre,
    required this.url,
    this.id,
    this.tipos = const <String>[],
  });
}
