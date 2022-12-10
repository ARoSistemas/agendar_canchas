import 'package:flutter_test/flutter_test.dart';

import 'package:canchas_aro/main.dart';
import 'package:canchas_aro/data/datasource/cache_db.dart';
import 'package:canchas_aro/domain/providers/home_ctrler.dart';
import 'package:canchas_aro/domain/entities/cancha.dart';
import 'package:canchas_aro/helpers/helpers.dart';

void main() {
  final testHelper = Helpers();

  test('Validación de Fechas en Clase Helpers', () async {
    final test1 = DateTime.now();
    final test2 = DateTime.parse('2022-12-01 00:00:00.000');

    final a = await testHelper.checkDate(selecteddate: test1);
    final b = await testHelper.checkDate(selecteddate: test2);

    // Falla el test
    // expect(a, '2022-12-10');

    // Pasa el Test
    expect(a, DateTime.now().toString().substring(0, 10));

    // Falla el test
    // expect(b, DateTime.now().toString().substring(0, 10));

    // Pasa el Test
    expect(b, 'vencido');
  });

  test('Validación de Disponibilidad de Canchas', () async {
    List<Cancha> lCanchas = [];
    LasCanchas qCancha = LasCanchas.a;

    final a = testHelper.valDisponibilidad(
      fecha: '',
      lCanchas: lCanchas,
      qCancha: qCancha,
    );

    // Falla el test
    // expect(a, 't,0');

    //Pasa el Test
    expect(a, 't,1');
  });

  testWidgets('Widget tests', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final dbCache = CacheDb();

    await dbCache.initPrefs();

    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('Eliminiar?'), findsOneWidget);
  });
}
