import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:termopanelescco/Models/columna.dart';
import 'package:termopanelescco/Models/fila.dart';
import 'package:termopanelescco/Models/plancha.dart';
import 'package:termopanelescco/Models/pedido.dart';
import 'package:termopanelescco/Models/produccion.dart';
import 'package:termopanelescco/Providers/produccion_provider.dart';
import 'package:termopanelescco/Screens/detalle_pedido_screen.dart';

import '../Models/detalle_pedido.dart';
import '../Utils/texts_app.dart';
import '../Widgets/appbar_widget.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({Key? key}) : super(key: key);

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  Future<List<Pedido>> readPedidos() async {
    List<Pedido> itemsPedido = [];

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("pedidos").get();

    for (var element in snapshot.docs) {
      itemsPedido.insert(
          0,
          Pedido(
              identificador: element["identificador"],
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

    return itemsPedido;
  }

  @override
  void initState() {
    readPedidos();
    super.initState();
  }

  final controllerLargo = TextEditingController();
  final controllerAlto = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Widget enviarProduccion(Pedido pedido) {
      return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 300,
            height: 320,
            child: ListView(
              padding: const EdgeInsets.only(left: 16, right: 16),
              children: [
                const ListTile(
                  title: Text(
                    "Ingresa dimensiones de plancha",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(bottom: 15, top: 15),
                    child: TextField(
                        controller: controllerLargo,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Largo mm"))),
                Container(
                    padding: const EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: TextFormField(
                        controller: controllerAlto,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Alto mm"))),
                SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          List<Fila>? filaO = [
                            for (var item in pedido.detallePedido
                                as List<DetallePedido>) ...[
                              for (var i = 0;
                                  i < item.cantidad!.toInt() * 2;
                                  i++) ...[
                                Fila(
                                    codigo: item.codigo,
                                    largo: item.largo,
                                    alto: item.alto,
                              
                                    cantidad: item.cantidad,
                                    m2: item.m2)
                              ]
                            ]
                          ];
                       

                          filaO.sort((a, b) => b.alto!.compareTo(a.alto!));

                          listPLancha() {
                          double largo = 0;
                          double alto = 0;
                          int lfila = 0;
                          int lcol = 0; 

                            final List<Plancha> pla = [];
                            final List<List<Columna>> colu = [[]];
                            final List<List<Fila>> fil = [[]];
                            int last = filaO.length - 1;

                            for (var i = 0; i < filaO.length; i++) {
                              largo += filaO[i].largo as num;

                              if (largo < int.parse(controllerLargo.text) &&
                                  filaO[i].alto as num <
                                      int.parse(controllerAlto.text) - alto) {
                                fil[lfila].insert(
                                    0,
                                    Fila(
                                    
                                      codigo: filaO[i].codigo,
                                      largo: filaO[i].largo,
                                      alto: filaO[i].alto,
                                      cantidad: filaO[i].cantidad,
                                      m2: filaO[i].m2,
                                    ));
                              } else if (filaO[i].largo as num >
                                  int.parse(controllerLargo.text) - largo) {
                                alto += filaO[i].alto as num;
                                largo = 0;

                                colu[lcol].insert(0, Columna(fila: fil[lfila]));
                                lfila = lfila + 1;
                                fil.add([]);

                                fil[lfila].insert(
                                    0,
                                    Fila(
                                    
                                      codigo: filaO[i].codigo,
                                      largo: filaO[i].largo,
                                      alto: filaO[i].alto,
                                      cantidad: filaO[i].cantidad,
                                      m2: filaO[i].m2,
                                    ));
                              } else if (filaO[i].alto as num >
                                  int.parse(controllerAlto.text) - alto) {
                                alto = 0;
                                largo = 0;
                                pla.insert(0, Plancha(columna: colu[lcol]));
                                lcol = lcol + 1;
                                colu.add([]);
                                fil.add([]);
                                lfila = lfila + 1;

                                fil[lfila].insert(
                                    0,
                                    Fila(
                                   
                                      codigo: filaO[i].codigo,
                                      largo: filaO[i].largo,
                                      alto: filaO[i].alto,
                                      cantidad: filaO[i].cantidad,
                                      m2: filaO[i].m2,
                                    ));
                              }
                              if (i == last) {
                                colu[lcol].insert(0, Columna(fila: fil[lfila]));

                                pla.insert(
                                    0,
                                    Plancha(
                                      columna: colu[lcol],
                                    ));
                              }
                            }

                            return pla;
                          }

                          final pedidoProduccion = Produccion(
                              identificador: pedido.identificador,
                              fecha: pedido.fecha,
                              plancha: listPLancha(),
                              usuario: pedido.usuario,
                              altoPLancha: int.parse(controllerAlto.text),
                              largoPlancha: int.parse(controllerLargo.text));
                          controllerAlto.clear;
                          controllerLargo.clear;
                          ProduccionP().addProduccion(pedidoProduccion);

                          Navigator.pushNamed(context, "/producciones");
                        },
                        child: const Text("Enviar a Produccion")))
              ],
            ),
          ));
    }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 39),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/pedidos/agregarpedido');
                              },
                              child: const Text(
                                TextApp.agregarpedido,
                                style: TextStyle(fontSize: 25),
                              ),
                            )),
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: const EdgeInsets.only(top: 39),
                          child: const Text(
                            "Pedidos",
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 200,
                        )
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),

                        // import de Widgets/widgetsProductos/tabla_widget
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: FutureBuilder(
                              future: readPedidos(),
                              builder: (context, AsyncSnapshot<List> snapshot) {
                                List pedidos = snapshot.data ?? [];

                                
                                return Column(children: [
                                  for (Pedido pedido in pedidos)
                                    Card(
                                      color: const Color.fromARGB(
                                          255, 201, 203, 213),
                                      child: ListTile(
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextButton(
                                                onPressed: () => showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return enviarProduccion(
                                                            pedido);
                                                      },
                                                    ),
                                                child: Row(
                                                  children: const [
                                                    Text("Enviar a produccion ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Icon(
                                                      Icons.send,
                                                      color: Color.fromARGB(
                                                          255, 62, 62, 62),
                                                    )
                                                  ],
                                                )),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute<void>(
                                                        builder: ((context) {
                                                  return DetallePedidoScreen(
                                                      pedido: pedido);
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
                                              ]),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          "Fecha:  ${pedido.fecha.toString()}",
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
