import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'package:canchas_aro/domain/entities/cancha.dart';
import 'package:canchas_aro/domain/providers/home_ctrler.dart';
import 'package:canchas_aro/data/datasource/cache_db.dart';
import 'package:canchas_aro/ui/pages/nuevo_agen/nuevo_agen.dart';
import 'package:canchas_aro/ui/pages/home/card_cancha.dart';

class HomePage extends StatefulWidget {
  static String idPage = 'HomePage';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbCache = CacheDb();

  @override
  void initState() {
    super.initState();

    // Recuperar la info del cache.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataCache();
    });
  }

  void getDataCache() {
    final ctrler = Provider.of<HomeCtrler>(context, listen: false);
    for (var cancha in dbCache.canchas) {
      final items = cancha.split('|');
      // Se crea el item
      final xCancha = Cancha(
        agendamientos: int.parse(items[0]),
        nombre: items[1],
        fecha: items[2],
        usuario: items[3],
        porcentaje: int.parse(items[4]),
        ciudad: items[5],
      );

      // Se agrega a la cola
      ctrler.agregar(item: xCancha);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrler = Provider.of<HomeCtrler>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamiento de Canchas'),
      ),
      backgroundColor: Colors.blue.shade100,
      body: ListView.builder(
        itemCount: ctrler.lCanchas.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SlideInLeft(
              duration: const Duration(milliseconds: 750),
              child: CardCanchas(
                laCancha: ctrler.lCanchas[index],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NuevoAgendamiento.idPage),
        tooltip: 'Nuevo Agendamiento',
        child: const Icon(Icons.add),
      ),
    );
  }
}
