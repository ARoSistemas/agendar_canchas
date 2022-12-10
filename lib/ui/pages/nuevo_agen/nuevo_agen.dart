import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'package:canchas_aro/helpers/helpers.dart';
import 'package:canchas_aro/data/datasource/cache_db.dart';
import 'package:canchas_aro/data/repositories/get_clima_repo.dart';
import 'package:canchas_aro/domain/entities/cancha.dart';
import 'package:canchas_aro/domain/providers/home_ctrler.dart';
import 'package:canchas_aro/domain/entities/selected_clima.dart';
import 'package:canchas_aro/ui/styles/buttons.dart';
import 'package:canchas_aro/ui/pages/nuevo_agen/usuario.dart';

class NuevoAgendamiento extends StatefulWidget {
  static String idPage = 'NuevoAgendamiento';

  const NuevoAgendamiento({Key? key}) : super(key: key);

  @override
  State<NuevoAgendamiento> createState() => _NuevoAgendamientoState();
}

class _NuevoAgendamientoState extends State<NuevoAgendamiento> {
  final classMyFunc = Helpers();

  bool isCupo = false;

  List<String> ret = ['f', '0'];

  String selectedDate = '';

  String msgDate = '';

  @override
  Widget build(BuildContext context) {
    final dbCache = CacheDb();
    final ctrler = Provider.of<HomeCtrler>(context);

    void _onPressedSave() {
      // Validar que exista nombre de usuario
      if (ctrler.usuario.isEmpty) {
        // Si el nombre esta vacio, se avisa
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          classMyFunc.mySnackData(
            msg: 'Introduzca un nombre para agendar',
          ),
        );
        return;
      }

      // Se crea el item
      final xCancha = Cancha(
        agendamientos: int.parse(ret[1]),
        nombre: ctrler.qCancha.toString().split('.')[1].toUpperCase(),
        fecha: selectedDate,
        usuario: ctrler.usuario,
        porcentaje: ctrler.elClima.porcentaje,
        ciudad: ctrler.qCiudad,
      );

      // Se agrega a la cola
      ctrler.agregar(item: xCancha);

      // Se guarda en cache.
      final laCancha =
          '${xCancha.agendamientos}|${xCancha.nombre}|${xCancha.fecha}|${xCancha.usuario}|${xCancha.porcentaje}|${xCancha.ciudad}';

      final saveCanchas = dbCache.canchas;
      saveCanchas.add(laCancha);

      dbCache.canchas = saveCanchas;

      Navigator.pop(context);
    }

    void _onPressedFecha() async {
      // Se muestra calendario para elegir fecha.
      final selecteddate = await showDatePicker(
        context: context,
        locale: const Locale('es'),
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2041),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
      );

      // Valido que la fecha sea correcta
      final getDate = await classMyFunc.checkDate(selecteddate: selecteddate);

      if (getDate.isNotEmpty) {
        if (getDate == 'vencido') {
          // La fecha seleccionada es anterior.
          selectedDate = '';
          msgDate = 'Sin fecha válida';
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            classMyFunc.mySnackData(
              msg: 'La fecha ha pasado, seleccione otra por favor.',
            ),
          );
        } else {
          // La fecha seleccionada es válida
          msgDate = 'Fecha seleccionada: ';
          selectedDate = getDate;

          // verifico que exista cupo en la cancha
          final checkDate = classMyFunc.valDisponibilidad(
            fecha: getDate,
            lCanchas: ctrler.lCanchas,
            qCancha: ctrler.qCancha!,
          );

          ret = checkDate.split(',');

          if (ret[0] == 'f') {
            // Si no existe cupo, se avisa con un snackbar
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              classMyFunc.mySnackData(
                msg: 'Cancha sin disponibilidad para la fecha seleccionada',
              ),
            );
            isCupo = false;
            selectedDate = '';
            msgDate = '';
          } else {
            // Si existe cupo, se pide el clima al API
            ctrler.showLoading = true;
            final getClima = await HttpGetClima.getClima(
              ciudad: ctrler.qCiudad,
            );
            ctrler.showLoading = false;

            isCupo = true;

            print('⭐ ${getClima.current.humidity}');

            // Se crea datos del clima de la cancha
            ctrler.elClima = SelectedClima(
              img: getClima.current.condition.icon,
              porcentaje: getClima.current.humidity,
              cancha: ctrler.qCancha.toString(),
            );
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuevo agendamiento',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 35),
            // Seleccionar fecha
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Seleccione Cancha',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Cancha A
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 170,
                child: RadioListTile(
                  title: const Text('Cancha A'),
                  value: LasCanchas.a,
                  groupValue: ctrler.qCancha,
                  onChanged: (LasCanchas? value) {
                    ctrler.qCancha = value;
                    ctrler.qCiudad = 'mexico';
                  },
                ),
              ),
            ),

            // Cancha B
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 170,
                child: RadioListTile(
                  title: const Text('Cancha B'),
                  value: LasCanchas.b,
                  groupValue: ctrler.qCancha,
                  onChanged: (LasCanchas? value) {
                    ctrler.qCancha = value;
                    ctrler.qCiudad = 'paris';
                  },
                ),
              ),
            ),

            // Cancha C
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 170,
                child: RadioListTile(
                  title: const Text('Cancha C'),
                  value: LasCanchas.c,
                  groupValue: ctrler.qCancha,
                  onChanged: (LasCanchas? value) {
                    ctrler.qCancha = value;
                    ctrler.qCiudad = 'london';
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Button Seleccionar Fecha
            ElevatedButton(
              style: StylesButtons.myStyle,
              child: const FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Seleccionar fecha',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () => _onPressedFecha(),
            ),

            const SizedBox(height: 30),

            // Datos del agendamiento
            SizedBox(
              width: 350,
              child: Column(
                children: [
                  // Mostrar fecha seleccionada o leyenda en caso de error.
                  Row(
                    children: [
                      Text(
                        msgDate,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        selectedDate,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Se muestra la probabilidad de lluvia
                  Visibility(
                    visible: selectedDate.isEmpty ? false : true,
                    child: Row(
                      children: [
                        const Text(
                          'Probabilidad de lluvia: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ' ${ctrler.elClima.porcentaje} % ',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        if (ctrler.elClima.img.isNotEmpty)
                          Image.network('https:${ctrler.elClima.img}',
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                            return loadingProgress == null
                                ? child
                                : const CircularProgressIndicator();
                          }),
                      ],
                    ),
                  ),

                  const Divider(),
                  Visibility(
                    visible: ctrler.showLoading,
                    child: const Center(
                      child: LinearProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),

            // Se pide el nombre del usuario
            Visibility(
              visible: selectedDate.isEmpty ? false : true,
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: ElUsuario(),
              ),
            ),

            // Guardar el evento
            Visibility(
              visible: selectedDate.isEmpty ? false : true,
              child: SlideInUp(
                duration: const Duration(milliseconds: 750),
                child: ElevatedButton(
                  style: StylesButtons.myStyleSave,
                  child: const FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      ' Guardar ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onPressed: () => _onPressedSave(),
                ),
              ),
            ),

            //
          ],
        ),
      ),
    );
  }
}
