import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:termopanelescco/Models/produccion.dart';

class ProduccionP with ChangeNotifier {
  Future addProduccion(Produccion produccion) async {
    final docProduccion =
        FirebaseFirestore.instance.collection("producciones").doc();
    final pedidoP = Produccion(
        id: docProduccion.id,
        identificador: produccion.identificador,
        fecha: produccion.fecha,
        plancha: produccion.plancha,
        usuario: produccion.usuario,
        altoPLancha: produccion.altoPLancha,
        largoPlancha: produccion.largoPlancha);

    final json = pedidoP.toJson();

    await docProduccion.set(json);
    notifyListeners();
  }
}
