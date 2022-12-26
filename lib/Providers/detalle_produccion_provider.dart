import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:termopanelescco/Models/plancha.dart';

import '../Models/produccion.dart';

class DetalleProduccionP with ChangeNotifier {
  List<TextEditingController> controllerLargo = [TextEditingController()];

  Future edit(Produccion produccion, bool estado) async {
    final docTermo = FirebaseFirestore.instance
        .collection("producciones")
        .doc(produccion.id);

    for (var plancha in produccion.plancha as List<Plancha>) {
      for (var columna in plancha.columna) {
        for (var fila in columna.fila) {

          docTermo.update({'plancha.0.columna.0.fila.0.estado': estado});
        }
      }
    }

    notifyListeners();
  }
}
