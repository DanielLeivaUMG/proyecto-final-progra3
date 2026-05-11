import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/nucleo/tema/colores_app.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/pantalla_arbol_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_lista_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_pila_pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/pantalla_tabla_hash_pokemon.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PokéPlanner'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ColoresApp.secundario.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_note_rounded,
                            size: 18,
                            color: ColoresApp.secundario,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Planifica tu colección',
                            style: TextStyle(
                              color: ColoresApp.secundario,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'PokéPlanner',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Organiza tu colección, explora Pokémon reales y consulta tu progreso en segundos.',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TarjetaAcceso(
              icono: Icons.travel_explore_rounded,
              titulo: 'Explorar Pokémon',
              descripcion:
                  'Descubre Pokémon y revisa información básica para empezar tu colección.',
              textoBoton: 'Explorar ahora',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaListaPokemon(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _TarjetaAcceso(
              icono: Icons.history_edu_rounded,
              titulo: 'Historial de exploración',
              descripcion: 'Revisa los Pokémon que exploraste recientemente.',
              textoBoton: 'Ver historial',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaPilaPokemon(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _TarjetaAcceso(
              icono: Icons.manage_search_rounded,
              titulo: 'Búsqueda rápida',
              descripcion:
                  'Busca rápidamente un Pokémon y accede a su información.',
              textoBoton: 'Buscar Pokémon',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaTablaHashPokemon(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _TarjetaAcceso(
              icono: Icons.account_tree_rounded,
              titulo: 'Arbol de Pokemon',
              descripcion:
                  'Visualiza Pokemon en estructura de arbol y realiza busqueda por nombre.',
              textoBoton: 'Abrir arbol',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaArbolPokemon(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColoresApp.acento.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF8A5D00),
                  ),
                ),
                title: const Text(
                  'Próximamente',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'Favoritos, árbol evolutivo y análisis de equipo.',
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _TarjetaAcceso extends StatelessWidget {
  const _TarjetaAcceso({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.textoBoton,
    required this.onPressed,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final String textoBoton;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColoresApp.primario.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icono, color: ColoresApp.primario),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(descripcion, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(textoBoton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
