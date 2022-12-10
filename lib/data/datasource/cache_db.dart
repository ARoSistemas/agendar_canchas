import 'package:shared_preferences/shared_preferences.dart';

class CacheDb {
  static final CacheDb _instancia = CacheDb._internal();

  factory CacheDb() => _instancia;

  CacheDb._internal();

  late SharedPreferences _dbCache;

  initPrefs() async => _dbCache = await SharedPreferences.getInstance();

  // Cancha(
  //   agendamientos: 0,
  //   nombre: A,
  //   fecha: 2022-12-01,
  //   usuario: Andy,
  //   porcentaje: 95,
  //   ciudad: mexico,
  // );

  // item = '0,A,2022-12-01,ANDY,95,mexico';

  /// Canchas guardadas
  List<String> get canchas => _dbCache.getStringList('canchas') ?? [];
  set canchas(List<String> value) => _dbCache.setStringList('canchas', value);

//
}
