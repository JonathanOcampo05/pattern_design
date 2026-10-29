import 'package:flutter/material.dart';

/// Sujeto observable: avisa a quien lo escuche cuando cambia.
class RegistroObservable extends ChangeNotifier {
  final List<double> _litros = [];

  List<double> get litros => List.unmodifiable(_litros);

  void guardar(double litros) {
    _litros.add(litros);
    notifyListeners();
  }
}

class PantallaObserver extends StatefulWidget {
  const PantallaObserver({super.key});

  @override
  State<PantallaObserver> createState() => _PantallaObserverState();
}

class _PantallaObserverState extends State<PantallaObserver> {
  final _registro = RegistroObservable();

  @override
  void dispose() {
    _registro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Observer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton(
            onPressed: () => _registro.guardar(12.5),
            child: const Text('Guardar 12.5 L'),
          ),
          const SizedBox(height: 16),
          PanelHistorial(registro: _registro),
          PanelMeta(registro: _registro, meta: 50),
        ],
      ),
    );
  }
}

/// Observador 1: se redibuja cuando el registro cambia.
class PanelHistorial extends StatelessWidget {
  const PanelHistorial({super.key, required this.registro});

  final RegistroObservable registro;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: registro,
      builder: (context, _) => Card(
        child: ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Historial'),
          subtitle: Text('${registro.litros.length} registros'),
        ),
      ),
    );
  }
}

/// Observador 2: también se redibuja cuando el registro cambia.
class PanelMeta extends StatelessWidget {
  const PanelMeta({super.key, required this.registro, required this.meta});

  final RegistroObservable registro;
  final double meta;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: registro,
      builder: (context, _) {
        final usados = registro.litros.fold<double>(0, (s, l) => s + l);
        return Card(
          child: ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Meta'),
            subtitle: Text('Quedan ${(meta - usados).toStringAsFixed(1)} L'),
          ),
        );
      },
    );
  }
}