import 'package:flutter/material.dart';

/// Interfaz de la estrategia: cada regla decide si acepta un valor.
abstract class ReglaStrategy {
  String get nombre;
  String get unidad;
  bool acepta(double valor);
}

/// Estrategia concreta 1.
class TopeAgua implements ReglaStrategy {
  @override
  String get nombre => 'Agua';
  @override
  String get unidad => 'L';
  @override
  bool acepta(double valor) => valor > 0 && valor <= 10000;
}

/// Estrategia concreta 2.
class TopeLuz implements ReglaStrategy {
  @override
  String get nombre => 'Luz';
  @override
  String get unidad => 'kWh';
  @override
  bool acepta(double valor) => valor > 0 && valor <= 500;
}

/// Contexto: usa la regla que le den, sin saber cuál es.
class ValidadorStrategy {
  ValidadorStrategy(this.regla);

  final ReglaStrategy regla;

  String resultado(double valor) {
    if (regla.acepta(valor)) {
      return 'aceptada';
    }
    return 'rechazada';
  }
}

class PantallaStrategy extends StatefulWidget {
  const PantallaStrategy({super.key});

  @override
  State<PantallaStrategy> createState() => _PantallaStrategyState();
}

class _PantallaStrategyState extends State<PantallaStrategy> {
  final _reglas = <ReglaStrategy>[TopeAgua(), TopeLuz()];
  late ReglaStrategy _regla = _reglas.first;
  double _valor = 800;

  @override
  Widget build(BuildContext context) {
    final resultado = ValidadorStrategy(_regla).resultado(_valor);
    return Scaffold(
      appBar: AppBar(title: const Text('Strategy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<ReglaStrategy>(
            segments: [
              for (final r in _reglas)
                ButtonSegment(value: r, label: Text(r.nombre)),
            ],
            selected: {_regla},
            onSelectionChanged: (s) => setState(() => _regla = s.first),
          ),
          const SizedBox(height: 16),
          Text('Lectura: ${_valor.toStringAsFixed(0)} ${_regla.unidad}'),
          Slider(
            value: _valor,
            max: 1200,
            onChanged: (v) => setState(() => _valor = v),
          ),
          Text(
            'ValidadorStrategy(${_regla.runtimeType}) → $resultado',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'Prueba 800: agua la acepta, luz la rechaza. '
                'ValidadorStrategy es la misma clase en los dos casos.',
          ),
        ],
      ),
    );
  }
}