import 'package:canchas_aro/domain/providers/home_ctrler.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        AssetImage,
        BorderRadius,
        BoxFit,
        BuildContext,
        Colors,
        Column,
        Container,
        DismissDirection,
        ElevatedButton,
        FittedBox,
        FontWeight,
        Image,
        MainAxisAlignment,
        MainAxisSize,
        Navigator,
        Radius,
        RoundedRectangleBorder,
        SizedBox,
        SnackBar,
        SnackBarBehavior,
        Text,
        TextAlign,
        TextStyle,
        Widget,
        showDialog;

import 'package:animate_do/animate_do.dart';

import 'package:canchas_aro/domain/entities/cancha.dart';
import 'package:canchas_aro/ui/styles/buttons.dart';

class Helpers {
  /// Se obtiene la fecha del selector fecha.
  Future<String> checkDate({
    required DateTime? selecteddate,
  }) async {
    String ret = '';
    bool isDateValid = false;

    // Formato de la fecha
    final hoy = _getDateFormated(
      fecha: DateTime.now().toString().substring(0, 10),
    );

    // Se valida la fecha
    if (selecteddate != null) {
      isDateValid = (hoy.compareTo(selecteddate) <= 0) ? true : false;
      ret =
          (isDateValid) ? selecteddate.toString().substring(0, 10) : 'vencido';
    }

    return ret;
  }

  /// Recibo Fecha con hora variable,
  /// Devuelvo fecha con hora 0.
  DateTime _getDateFormated({required String fecha}) {
    return DateTime.parse('$fecha 00:00:00.000');
  }

  /// Reviso que la fecha no tenga más de 3 eventos en cada cancha
  String valDisponibilidad({
    required String fecha,
    required List<Cancha> lCanchas,
    required LasCanchas qCancha,
  }) {
    String ret = ',';
    int nAgendadosA = 1;
    int nAgendadosB = 1;
    int nAgendadosC = 1;

    // Se obtienen los eventos de la fecha de las canchas.
    for (var item in lCanchas) {
      switch (item.nombre) {
        case 'A':
          if (item.fecha.toString().substring(0, 10) == fecha) {
            ++nAgendadosA;
          }

          break;
        case 'B':
          if (item.fecha.toString().substring(0, 10) == fecha) {
            ++nAgendadosB;
          }
          break;

        case 'C':
          if (item.fecha.toString().substring(0, 10) == fecha) {
            ++nAgendadosC;
          }
          break;

        default:
      }
    }

    // Valido capacidad de la cancha por la fecha seleccionada
    switch (qCancha) {
      // Validacion para la Cancha A
      case LasCanchas.a:
        ret = (nAgendadosA >= 4) ? 'f,$nAgendadosA' : 't,$nAgendadosA';

        break;
      // Validacion para la Cancha B
      case LasCanchas.b:
        ret = (nAgendadosB >= 4) ? 'f,$nAgendadosB' : 't,$nAgendadosB';

        break;
      // Validacion para la Cancha C
      case LasCanchas.c:
        ret = (nAgendadosC >= 4) ? 'f,$nAgendadosC' : 't,$nAgendadosC';

        break;
      default:
    }

    return ret;
  }

  SnackBar mySnackData({required msg}) {
    return SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.amber.shade300,
      content: Text(
        msg,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<bool> showAlert({
    required BuildContext context,
  }) async {
    bool ret = false;

    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return ZoomIn(
            duration: const Duration(milliseconds: 350),
            child: AlertDialog(
              backgroundColor: Colors.blue.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 250,
                    height: 250,
                    color: Colors.blue.shade100,
                    child: const Image(
                      image: AssetImage('assets/png/cancel.png'),
                      height: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '¿Eliminiar el Agendamiento?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                ElevatedButton(
                  style: StylesButtons.myStyle,
                  onPressed: () => {
                    Navigator.pop(context),
                    ret = true,
                  },
                  child: const Text('Si, por favor'),
                ),
              ],
            ),
          );
        });
    return ret;
  }
}
