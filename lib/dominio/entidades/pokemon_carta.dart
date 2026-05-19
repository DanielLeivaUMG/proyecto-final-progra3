class PokemonCarta {
  const PokemonCarta({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.imagenUrl,
    required this.hp,
    required this.ataque,
    required this.defensa,
    required this.velocidad,
  });

  final int id;
  final String nombre;
  final String tipo;
  final String imagenUrl;
  final int hp;
  final int ataque;
  final int defensa;
  final int velocidad;

  int get poderTotal => hp + ataque + defensa + velocidad;
}
