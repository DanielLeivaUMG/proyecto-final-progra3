import 'package:flutter/material.dart';

class PestanaAnalisisHash extends StatelessWidget {
  const PestanaAnalisisHash({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'La matriz de impacto defensivo se implementará en la siguiente fase.',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
