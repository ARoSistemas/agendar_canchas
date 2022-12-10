import 'package:canchas_aro/data/model/clima.dart';

abstract class GetClimaRepository {
  // Obtener el clima
  static Future<Clima?> getClima({required String ciudad}) {
    throw UnimplementedError();
  }
}
