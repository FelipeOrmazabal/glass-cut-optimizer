import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:termopanelescco/Models/pedido.dart';

import 'package:termopanelescco/Screens/detalle_presupuesto_sreen.dart';

import '../Models/detalle_pedido.dart';

import '../Widgets/appbar_widget.dart';

class PresupuestosScreen extends StatefulWidget {
  const PresupuestosScreen({Key? key}) : super(key: key);

  @override
  State<PresupuestosScreen> createState() => _PresupuestosScreenState();
}

class _PresupuestosScreenState extends State<PresupuestosScreen> {
  Future<List<Pedido>> readPresupuestos() async {
    List<Pedido> itemsPresupuesto = [];

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("presupuestos").orderBy("fecha").get();

    for (var element in snapshot.docs) {
      itemsPresupuesto.insert(
          0,
          Pedido(
              identificador: element["identificador"],
               icodigo: element["icodigo"],
              fecha: (element["fecha"] as Timestamp).toDate(),
              detallePedido: [
                for (var i = 0;
                    i < (element["detallePedido"] as List).length;
                    i++) ...[
                  DetallePedido(
                      codigo: element["detallePedido"][i]["codigo"],
                      vidrio1: element["detallePedido"][i]["vidrio1"],
                      separador: element["detallePedido"][i]["separador"],
                      vidrio2: element["detallePedido"][i]["vidrio2"],
                      largo: element["detallePedido"][i]["largo"],
                      alto: element["detallePedido"][i]["alto"],
                      cantidad: element["detallePedido"][i]["cantidad"],
                      m2: element["detallePedido"][i]["m2"],
                      valorM2: element["detallePedido"][i]["valorM2"],
                      precio: element["detallePedido"][i]["precio"])
                ],
              ],
              usuario: element["usuario"],
              total: element["total"]));
    }

    return itemsPresupuesto;
  }

  @override
  void initState() {
    readPresupuestos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Import de widgets/appbar_widget (para importar appbar requiere PreferredSize)
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBarWidget(),
      ),

      body: ListView(children: [
        Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 39),
                      child: const Text(
                        "Presupuestos",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),

                        // import de Widgets/widgetsProductos/tabla_widget
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: FutureBuilder(
                              future: readPresupuestos(),
                              builder: (context, AsyncSnapshot<List> snapshot) {
                                List presupuestos = snapshot.data ?? [];
                                return Column(children: [
                                  for (Pedido pedido in presupuestos)
                                    Card(
                                      color: const Color.fromARGB(
                                          255, 201, 203, 213),
                                      child: ListTile(
                                        subtitle: Text(pedido.fecha.toString()),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute<void>(
                                                          builder: ((context) {
                                                    return DetallePresupuestoScreen(
                                                        presupuesto: pedido);
                                                  })));
                                                },
                                                child: Row(children: const [
                                                  Text(
                                                    "Ver detalles ",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Icon(
                                                      Icons
                                                          .remove_red_eye_rounded,
                                                      color: Color.fromARGB(
                                                          255, 62, 62, 62))
                                                ])),
                                          ],
                                        ),
                                        title: Text(
                                            pedido.identificador.toString()),
                                      ),
                                    )
                                ]);
                              },
                            ))),
                  ],
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
