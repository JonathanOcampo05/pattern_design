import 'package:flutter/material.dart';

import 'casos/adapter.dart';
import 'casos/factory.dart';
import 'casos/inyeccion_dependencias.dart';
import 'casos/observer.dart';
import 'casos/repository.dart';
import 'casos/strategy.dart';

void main() {
  final almacen = ConsumoRepositoryEnMemoria();
  final lector = MedidorAdapter(MedidorLegado());
  runApp(EcoTrackApp(almacen: almacen, lector: lector));
}

class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({
    super.key,
    required this.almacen,
    required this.lector,
  });

  final ConsumoRepository almacen;
  final MedidorAdapter lector;

  @override
  Widget build(BuildContext context) {
    final casos = <(String, String, Widget)>[
      (
      'Repository',
      'Ocultar de dónde salen los datos.',
      PantallaRepository(almacen: almacen),
      ),
      (
      'Adapter',
      'Traducir un formato ajeno al de la app.',
      PantallaAdapter(lector: lector),
      ),
      (
      'Factory',
      'Centralizar la construcción de un objeto según el caso.',
      const PantallaFactory(),
      ),
      (
      'Strategy',
      'Intercambiar una regla sin copiar if.',
      const PantallaStrategy(),
      ),
      (
      'Observer',
      'Avisar a varios interesados sin nombrarlos.',
      const PantallaObserver(),
      ),
      (
      'Inyección de dependencias',
      'Entregar desde fuera el objeto del que se depende.',
      const PantallaInyeccionDependencias(),
      ),
    ];

    return MaterialApp(
      title: 'EcoTrack',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Patrones de EcoTrack')),
          body: ListView(
            children: [
              for (final (i, (nombre, problema, pagina)) in casos.indexed)
                ListTile(
                  leading: CircleAvatar(child: Text('${i + 1}')),
                  title: Text(nombre),
                  subtitle: Text(problema),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => pagina),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}