import 'dart:math';

import 'package:flutter/material.dart';

/// Adaptee: el aparato viejo, solo devuelve texto.
class MedidorLegado {
  MedidorLegado({Random? azar}) : _azar = azar ?? Random();

  final Random _azar;

  String leerCrudo() {
    final litros = (_azar.nextInt(200) + 1) / 10;
    return '$litros L';
  }
}

/// Adapter: traduce el texto del medidor viejo a un double.
class MedidorAdapter {
  MedidorAdapter(this.legado);

  final MedidorLegado legado;

  double leerLitros() {
    final texto = legado.leerCrudo();
    final numero = texto.split(' ').first;
    return double.parse(numero);
  }
}

class PantallaAdapter extends StatefulWidget {
  const PantallaAdapter({super.key, required this.lector});

  final MedidorAdapter lector;

  @override
  State<PantallaAdapter> createState() => _PantallaAdapterState();
}

class _PantallaAdapterState extends State<PantallaAdapter> {
  final List<double> _lecturas = [];

  @override
  Widget build(BuildContext context) {
    final total = _lecturas.fold<double>(0, (s, l) => s + l);
    return Scaffold(
      appBar: AppBar(title: const Text('Adapter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'El aparato viejo sigue devolviendo texto. La app necesita un double.',
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.speed),
            label: const Text('Leer medidor'),
            onPressed: () =>
                setState(() => _lecturas.add(widget.lector.leerLitros())),
          ),
          const SizedBox(height: 16),
          Text('Lecturas (double): $_lecturas'),
          Text(
            'Suma: ${total.toStringAsFixed(1)} L',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}