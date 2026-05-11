import 'package:flutter/material.dart';
import 'package:proyecto_final_progra3/dominio/entidades/pokemon.dart';
import 'package:proyecto_final_progra3/presentacion/pantallas/arbol_pokemon/widgets/seccion_arbol.dart';

class PestanaAnalisisArbol extends StatelessWidget {
  const PestanaAnalisisArbol({
    super.key,
    required this.estaVacio,
    required this.nombreRaiz,
    required this.totalNodos,
    required this.profundidadMaxima,
    required this.evolucionesDirectas,
    required this.tipoArbol,
    required this.evolucionesFinales,
    required this.ultimoNombreBuscado,
    required this.rutaUltimaBusqueda,
  });

  final bool estaVacio;
  final String nombreRaiz;
  final int totalNodos;
  final int profundidadMaxima;
  final int evolucionesDirectas;
  final String tipoArbol;
  final List<Pokemon> evolucionesFinales;
  final String? ultimoNombreBuscado;
  final List<Pokemon> rutaUltimaBusqueda;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SeccionArbol(texto: 'Analisis', icono: Icons.analytics_rounded),
          const SizedBox(height: 10),
          if (estaVacio)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Carga un arbol para ver su analisis.'),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Analisis del arbol evolutivo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Pokemon raiz: $nombreRaiz'),
                    Text('Total de nodos: $totalNodos'),
                    Text('Profundidad maxima: $profundidadMaxima'),
                    Text(
                      'Cantidad de evoluciones directas: $evolucionesDirectas',
                    ),
                    Text('Tipo de arbol: $tipoArbol'),
                    const SizedBox(height: 8),
                    Text(
                      'Evoluciones finales: ${evolucionesFinales.isEmpty ? "Sin datos" : evolucionesFinales.map((Pokemon pokemon) => pokemon.nombre).join(", ")}',
                    ),
                    const SizedBox(height: 8),
                    if (ultimoNombreBuscado == null)
                      const Text(
                        'Ruta del ultimo Pokemon buscado: sin busqueda.',
                      )
                    else if (rutaUltimaBusqueda.isEmpty)
                      Text(
                        'Ruta del ultimo Pokemon buscado ($ultimoNombreBuscado): no existe en el arbol.',
                      )
                    else
                      Text(
                        'Ruta del ultimo Pokemon buscado ($ultimoNombreBuscado): ${rutaUltimaBusqueda.map((Pokemon pokemon) => pokemon.nombre).join(" -> ")}',
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
