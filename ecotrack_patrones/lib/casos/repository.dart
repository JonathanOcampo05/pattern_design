import 'package:flutter/material.dart';

/// Contrato del repositorio: la pantalla solo conoce esto.
abstract class ConsumoRepository {
  void guardar(double litros);
  List<double> todos();
}

/// Implementación concreta: hoy los datos viven en una lista en memoria.
class ConsumoRepositoryEnMemoria implements ConsumoRepository {
  final List<double> _litros = [];

  @override
  void guardar(double litros) => _litros.add(litros);

  @override
  List<double> todos() => List<double>.from(_litros);
}

class PantallaRepository extends StatefulWidget {
  const PantallaRepository({super.key, required this.almacen});

  final ConsumoRepository almacen;

  @override
  State<PantallaRepository> createState() => _PantallaRepositoryState();
}

class _PantallaRepositoryState extends State<PantallaRepository> {
  final _litros = TextEditingController();

  @override
  void dispose() {
    _litros.dispose();
    super.dispose();
  }

  void _alPulsarGuardar() {
    final valor = double.tryParse(_litros.text);
    if (valor == null) return;
    setState(() => widget.almacen.guardar(valor));
    _litros.clear();
  }

  @override
  Widget build(BuildContext context) {
    final guardados = widget.almacen.todos();
    return Scaffold(
      appBar: AppBar(title: const Text('Repository')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'La pantalla habla con un contrato. Hoy los litros viven en una lista.',
          ),
          TextField(
            controller: _litros,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Litros'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _alPulsarGuardar,
            child: const Text('Guardar'),
          ),
          const Divider(height: 32),
          Text('almacen.todos() → $guardados'),
        ],
      ),
    );
  }
}