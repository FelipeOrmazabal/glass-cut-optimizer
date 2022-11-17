import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:termopanelescco/Models/pedido.dart';

class PresupuestoP with ChangeNotifier {


  Future addPresupuesto(Pedido pedido) async {
    final docPedido = FirebaseFirestore.instance
        .collection("presupuestos")
        .doc();
       
    final pedidoP = Pedido(
        id: docPedido.id,
        identificador: pedido.identificador,
        fecha: pedido.fecha,
        detallePedido: pedido.detallePedido,
        total: pedido.total,
        usuario: pedido.usuario);

    final json = pedidoP.toJson();

    await docPedido.set(json);
    notifyListeners();
  }



  
}
