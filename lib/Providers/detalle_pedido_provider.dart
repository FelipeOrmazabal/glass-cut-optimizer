import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../Models/detalle_pedido.dart';

class DetallePedidoP with ChangeNotifier {
  final controllerCodigos = TextEditingController();
  final controllerTotal = TextEditingController();
  final controllerIdentificador = TextEditingController();
  List<TextEditingController> controllerCodigo = [];
  List<TextEditingController> controllerLargo = [];
  List<TextEditingController> controllerAlto = [];
  List<TextEditingController> controllerCantidad = [];
  List<TextEditingController> controllerM2 = [];
  List<TextEditingController> controllerValorM2 = [];
  List<TextEditingController> controllerPrecio = [];
  List<String> currentvalueS = [];
  List<String> currentvalueV1 = [];
  List<String> currentvalueV2 = [];

  List<DetallePedido> detalle = [];

  int count = 0;
  bool vista  = false;
  double altura = 1;
  double alturaS = 8;
  void addFila(
    String currentValueV1,
    String currentValueV2,
    String currentValueS,
  ) {
    count++;
    altura = altura + 1;
    alturaS = alturaS + 1;
    controllerCodigo.add(TextEditingController());
    controllerLargo.add(TextEditingController());
    controllerAlto.add(TextEditingController());
    controllerCantidad.add(TextEditingController());
    controllerM2.add(TextEditingController());
    controllerValorM2.add(TextEditingController());
    controllerPrecio.add(TextEditingController());
    currentvalueS.add(currentValueS);
    currentvalueV1.add(currentValueV1);
    currentvalueV2.add(currentValueV2);

    notifyListeners();
  }
void addFila2(
    String currentValueV1,
    String currentValueV2,
    String currentValueS,
    String codigo,
    String largo,
    String alto,
    String cantidad,
    String m2,
    String valorM2,
    String precio,
  ) {
   
    altura = altura + 1;
    alturaS = alturaS + 1;
    controllerCodigo.add(TextEditingController(text: codigo));
    controllerLargo.add(TextEditingController(text: largo));
    controllerAlto.add(TextEditingController(text: alto));
    controllerCantidad.add(TextEditingController(text: cantidad));
    controllerM2.add(TextEditingController(text: m2));
    controllerValorM2.add(TextEditingController(text: valorM2));
    controllerPrecio.add(TextEditingController(text: precio));
    currentvalueS.add(currentValueS);
    currentvalueV1.add(currentValueV1);
    currentvalueV2.add(currentValueV2);
 count++;
    notifyListeners();
  }
  void deleteFila() {
    if (count > 0) {
      count--;
      altura = altura - 1;
      alturaS = alturaS - 1;
      controllerCodigo.removeLast();
      controllerAlto.removeLast();
      controllerCantidad.removeLast();
      controllerLargo.removeLast();
      controllerM2.removeLast();
      controllerPrecio.removeLast();
      controllerValorM2.removeLast();
      currentvalueS.removeLast();
      currentvalueV1.removeLast();
      currentvalueV2.removeLast();
      notifyListeners();
    }
  }

  void codigos(String value) {
    for (var i = 0; i < count; i++) {
      controllerCodigo[i].text = "$value-${(i + 1).toString()}";
    }
  }

  void agregarDetalle() {
    for (var i = 0; i < count; i++) {
      detalle.add(DetallePedido(
          codigo: controllerCodigo[i].text,
          vidrio1: currentvalueV1[i],
          separador: currentvalueS[i],
          vidrio2: currentvalueV2[i],
          largo: int.parse(controllerLargo[i].text),
          alto: int.parse(controllerAlto[i].text),
          cantidad: int.parse(controllerCantidad[i].text),
          m2: double.parse(controllerM2[i].text),
          valorM2: int.parse(controllerValorM2[i].text),
          precio: double.parse(controllerPrecio[i].text)));
    }
  }

  void total() {
    double total = 0;
    for (var i = 0; i < count; i++) {
      total += int.parse(controllerPrecio[i].text);
    }
    controllerTotal.text = total.toString();
  }

  void precio(int index) {
    double precio = (double.parse(controllerM2[index].text) *
            int.parse(controllerValorM2[index].text)) *
        int.parse(controllerCantidad[index].text);

    controllerPrecio[index].text = precio.toStringAsFixed(0).toString();
    total();
  }

  void m2(int index) {
    if (controllerLargo[index].text != "" && controllerAlto[index].text != "") {
      double m2 = (int.parse(controllerLargo[index].text) *
          int.parse(controllerAlto[index].text) /
          1000000);
      controllerM2[index].text = m2.toString();

      if (controllerCantidad[index].text != "") {
        precio(index);
      }
    }
  }
  Future delete(String id) async {
    final docPedido = FirebaseFirestore.instance
        .collection("pedidos")
       
        .doc(id);

    docPedido.delete();

    notifyListeners();
  }
}
