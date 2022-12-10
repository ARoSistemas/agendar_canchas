import 'package:canchas_aro/domain/entities/selected_clima.dart';
import 'package:flutter/material.dart';

import 'package:canchas_aro/domain/entities/cancha.dart';

enum LasCanchas { a, b, c }

class HomeCtrler with ChangeNotifier {
  HomeCtrler() {
    // sin inicializadores
  }

  // La lista de las canchas para la vista
  List<Cancha> _lCanchas = [];
  List<Cancha> get lCanchas => _lCanchas;
  set lCanchas(List<Cancha> tmpCancha) {
    _lCanchas = tmpCancha;
    notifyListeners();
  }

  /// Elimino una cacha de la vista y retorno una lista para guardar en cache
  List<String> delItem({required Cancha item}) {
    final List<String> newCanchas = [];

    // Eliminar de la vista
    _lCanchas.removeWhere(
      (element) => (element.nombre == item.nombre &&
          element.fecha == item.fecha &&
          element.agendamientos == item.agendamientos),
    );

    // Eliminar en el cache.
    for (var xCancha in lCanchas) {
      // Se guarda en cache.
      final laCancha =
          '${xCancha.agendamientos}|${xCancha.nombre}|${xCancha.fecha}|${xCancha.usuario}|${xCancha.porcentaje}|${xCancha.ciudad}';

      // Se retorna nuevo cache
      newCanchas.add(laCancha);
    }

    notifyListeners();

    return newCanchas;
  }

  /// Ordeno de forma ascedente por fecha las canchas
  void ordenar() {
    _lCanchas.sort((a, b) => a.fecha.compareTo(b.fecha));
  }

  /// Agrego una nueva cancha a la vista
  void agregar({required Cancha item}) {
    lCanchas.add(item);
    ordenar();
    notifyListeners();
  }

  /// Nombre del usuario a reservar
  String _usuario = '';
  String get usuario => _usuario;
  set usuario(String value) {
    _usuario = value;
    notifyListeners();
  }

  bool _showLoading = false;
  bool get showLoading => _showLoading;
  set showLoading(bool value) {
    _showLoading = value;
    notifyListeners();
  }

  SelectedClima _elClima = SelectedClima(
    img: '',
    porcentaje: 0,
    cancha: '',
  );
  SelectedClima get elClima => _elClima;
  set elClima(SelectedClima value) {
    _elClima = value;
    notifyListeners();
  }

  LasCanchas? _qCancha = LasCanchas.a;
  LasCanchas? get qCancha => _qCancha;
  set qCancha(LasCanchas? value) {
    _qCancha = value;
    notifyListeners();
  }

  String _qCiudad = 'mexico';
  String get qCiudad => _qCiudad;
  set qCiudad(String value) {
    _qCiudad = value;
    notifyListeners();
  }

//
}
