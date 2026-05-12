import 'package:flutter/material.dart';

class PestanaRecientesHash extends StatelessWidget {
  const PestanaRecientesHash({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Los equipos recientes se agregarán en la siguiente fase.',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
