class Pokemon {
  final String nombre;
  final String url;

  const Pokemon({
    required this.nombre,
    required this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      nombre: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}