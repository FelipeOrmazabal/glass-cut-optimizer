import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:termopanelescco/Models/pedido.dart';

class PedidoP with ChangeNotifier {
  Future addPedido(Pedido pedido) async {
    final docPedido = FirebaseFirestore.instance
        .collection("pedidos")
        .doc();
    final pedidoP = Pedido(
        id: docPedido.id,
        icodigo: pedido.icodigo,
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
