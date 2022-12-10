import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:canchas_aro/domain/providers/home_ctrler.dart';
import 'package:canchas_aro/ui/pages/home/home.dart';
import 'package:canchas_aro/ui/pages/nuevo_agen/nuevo_agen.dart';
import 'package:canchas_aro/data/datasource/cache_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbCache = CacheDb();

  await dbCache.initPrefs();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeCtrler()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo - Canchas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomePage.idPage,
        routes: {
          HomePage.idPage: (_) => const HomePage(),
          NuevoAgendamiento.idPage: (_) => const NuevoAgendamiento(),
        },
      ),
    );
  }
}
