import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:canchas_aro/domain/providers/home_ctrler.dart';

class ElUsuario extends StatefulWidget {
  const ElUsuario({Key? key}) : super(key: key);

  @override
  State<ElUsuario> createState() => _ElUsuarioState();
}

class _ElUsuarioState extends State<ElUsuario> {
  final TextEditingController _nombreCtrler = TextEditingController();

  @override
  void dispose() {
    _nombreCtrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrler = Provider.of<HomeCtrler>(context);
    return TextFormField(
      controller: _nombreCtrler,
      decoration: const InputDecoration(
        labelText: 'Nombre para agendar',
        labelStyle: TextStyle(color: Colors.black),
        suffixIcon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.characters,
      onFieldSubmitted: (valor) {
        _nombreCtrler.text = _nombreCtrler.text.toUpperCase();
        ctrler.usuario = _nombreCtrler.text;
      },
      onChanged: (value) {
        _nombreCtrler.text = _nombreCtrler.text.toUpperCase();
        _nombreCtrler.selection = TextSelection.fromPosition(
          TextPosition(
            offset: _nombreCtrler.text.length,
          ),
        );
        ctrler.usuario = _nombreCtrler.text;
      },
      maxLength: 40,
    );
  }
}
