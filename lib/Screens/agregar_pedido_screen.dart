import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termopanelescco/Models/pedido.dart';
import 'package:termopanelescco/Models/termo.dart';
import 'package:termopanelescco/Providers/agregar_detalle_pedido_provider.dart';
import 'package:termopanelescco/Providers/pedido_provider.dart';
import 'package:termopanelescco/Providers/presupuesto_provider.dart';
import '../Utils/texts_app.dart';
//prueba3

class AgregarPedidoScreen extends StatefulWidget {
  const AgregarPedidoScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<AgregarPedidoScreen> createState() {
    return _AgregarPedidoScreenState();
  }
}

class _AgregarPedidoScreenState extends State<AgregarPedidoScreen> {
  List<Termo> termos = [];
  List<String> vidrioAll = [];
  List<String> separadorAll = [];

  Future readTermos() async {
    List<Termo> itemsTermo = [];

    if (itemsTermo.isEmpty) {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("termopaneles").get();

      for (var element in snapshot.docs) {
        itemsTermo.insert(
            0,
            Termo(
                valor: element["valor"],
                separador: element["separador"],
                vidrio1: element["vidrio1"],
                vidrio2: element["vidrio2"]));
      }
    }

    // ignore: await_only_futures
    for (var item in await itemsTermo) {
      vidrioAll.add(item.vidrio1.toString());
      vidrioAll.add(item.vidrio2.toString());
      separadorAll.add(item.separador.toString());
    }
  termos = itemsTermo;

  }

  @override
  void initState() {
    readTermos();
    super.initState();
  }

  List<List<String>> vidrios1 = [];
  List<List<String>> separador = [];
  List<List<String>> vidrios2 = [];

  @override
  Widget build(BuildContext context) {
    final detallePedidoP = Provider.of<AgregarDetallePedidoP>(context);
    final presupuestoP = Provider.of<PresupuestoP>(context);
    final pedidoP = Provider.of<PedidoP>(context);

    void valor(int index) {
       detallePedidoP.controllerValorM2[index].text = 27000.toString();
      for (var item in termos) {
        if (detallePedidoP.currentvalueV1[index] == item.vidrio1 &&
                detallePedidoP.currentvalueS[index] == item.separador &&
                detallePedidoP.currentvalueV2[index] == item.vidrio2 ||
            detallePedidoP.currentvalueV2[index] == item.vidrio1 &&
                detallePedidoP.currentvalueS[index] == item.separador &&
                detallePedidoP.currentvalueV1[index] == item.vidrio2) {
          detallePedidoP.controllerValorM2[index].text = item.valor.toString();
        }
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // Import de widgets/appbar_widget (para importar appbar requiere PreferredSize)
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/pedidos', (Route<dynamic> route) => false);
              detallePedidoP.controllerAlto = [];
              detallePedidoP.controllerLargo = [];
              detallePedidoP.controllerCantidad = [];
              detallePedidoP.controllerCodigo = [];
              detallePedidoP.controllerCodigos.clear();
              detallePedidoP.controllerIdentificador.clear();
              detallePedidoP.controllerM2 = [];
              detallePedidoP.controllerValorM2 = [];
              detallePedidoP.controllerTotal.clear();
              detallePedidoP.controllerPrecio = [];
              detallePedidoP.currentvalueS = [];
              detallePedidoP.currentvalueV1 = [];
              detallePedidoP.currentvalueV2 = [];
              detallePedidoP.altura = 1;
              detallePedidoP.alturaS = 8;

              detallePedidoP.count = 0;
              detallePedidoP.detalle.clear();
            },
          ),
          title: const Text(TextApp.tituloAppbar),
        
        ),
        body: ListView(children: [
          Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 68 * detallePedidoP.alturaS,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 30, bottom: 20),
                          child: const Text(
                            "Agregar Pedido",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 80,
                              child: TextFormField(
                                  controller: detallePedidoP.controllerCodigos,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Codigo")),
                            ),
                            //cambio
                            SizedBox(
                              height: 50,
                              width: 500,
                              child: TextFormField(
                                  controller:
                                      detallePedidoP.controllerIdentificador,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Identificador Pedido")),
                            ),
                            const SizedBox(
                              height: 1,
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: const Color.fromARGB(255, 226, 226, 226),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text("codigo          ",
                                  style: TextStyle(fontSize: 17)),
                              Text("vidrio 1", style: TextStyle(fontSize: 17)),
                              Text("      separador      ", style: TextStyle(fontSize: 17)),
                              Text("vidrio 2", style: TextStyle(fontSize: 17)),
                              Text("           largo mm",
                                  style: TextStyle(fontSize: 17)),
                              Text("alto mm", style: TextStyle(fontSize: 17)),
                              Text("cantidad",
                                  style: TextStyle(fontSize: 17)),
                              Text("M^2", style: TextStyle(fontSize: 17)),
                              Text("valor M^2", style: TextStyle(fontSize: 17)),
                              Text("precio", style: TextStyle(fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: SizedBox(
                          height: 68 * detallePedidoP.altura,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListView.separated(
                            itemCount: detallePedidoP.count,
                            itemBuilder: (BuildContext context, int index) {
                              detallePedidoP.codigos(
                                  detallePedidoP.controllerCodigos.text);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 80,
                                    child: TextFormField(
                                        controller: detallePedidoP
                                            .controllerCodigo[index],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        )),
                                  ),
                                  SizedBox(
                                      height: 50,
                                      width: 160,
                                      child: DropdownButtonFormField(
                                          value:
                                              vidrios1[index].first.toString(),
                                          items: vidrios1[index]
                                              .toSet()
                                              .map((items) => DropdownMenuItem(
                                                    child: Text(items),
                                                    value: items,
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            detallePedidoP
                                                    .currentvalueV1[index] =
                                                value.toString();
                                            valor(index);
                                            if (detallePedidoP
                                                    .controllerM2[index].text !=
                                                "") {
                                              detallePedidoP.precio(index);
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ))),
                                  SizedBox(
                                      height: 50,
                                      width: 170,
                                      child: DropdownButtonFormField(
                                          value:
                                              separador[index].first.toString(),
                                          items: separador[index]
                                              .toSet()
                                              .map((items) => DropdownMenuItem(
                                                    child: Text(items),
                                                    value: items,
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            detallePedidoP
                                                    .currentvalueS[index] =
                                                value.toString();
                                            valor(index);
                                            if (detallePedidoP
                                                    .controllerM2[index].text !=
                                                "") {
                                              detallePedidoP.precio(index);
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ))),
                                  SizedBox(
                                      height: 50,
                                      width: 160,
                                      child: DropdownButtonFormField(
                                          value:
                                              vidrios2[index].first.toString(),
                                          items: vidrios2[index]
                                              .toSet()
                                              .map((items) => DropdownMenuItem(
                                                    child: Text(items),
                                                    value: items,
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            detallePedidoP
                                                    .currentvalueV2[index] =
                                                value.toString();
                                            valor(index);
                                            if (detallePedidoP
                                                    .controllerM2[index].text !=
                                                "") {
                                              detallePedidoP.precio(index);
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ))),
                                  SizedBox(
                                    height: 50,
                                    width: 120,
                                    child: TextFormField(
                                        onChanged: (value) {
                                          detallePedidoP.m2(index);
                                        },
                                        controller: detallePedidoP
                                            .controllerLargo[index],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 120,
                                    child: TextFormField(
                                        onChanged: (value) {
                                          detallePedidoP.m2(index);
                                        },
                                        controller: detallePedidoP
                                            .controllerAlto[index],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: TextFormField(
                                        onChanged: (value) {
                                          detallePedidoP.precio(index);
                                        },
                                        controller: detallePedidoP
                                            .controllerCantidad[index],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 80,
                                    child: TextFormField(
                                        onChanged: (value) {
                                          detallePedidoP.precio(index);
                                        },
                                        controller:
                                            detallePedidoP.controllerM2[index],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: TextFormField(
                                        onChanged: (value) {
                                          detallePedidoP.total();
                                          detallePedidoP.precio(index);
                                        },
                                        controller: detallePedidoP
                                            .controllerValorM2[index],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: TextFormField(
                                        onChanged: (value) {
                                          detallePedidoP.total();
                                        },
                                        controller: detallePedidoP
                                            .controllerPrecio[index],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        )),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                heroTag: "caca",
                                child: const Icon(Icons.delete),
                                onPressed: () {
                                  detallePedidoP.deleteFila();
                                  vidrios1.last.clear();
                                  vidrios2.last.clear();
                                  separador.last.clear();
                                }),
                          ),
                          Container(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(
                                  child: const Icon(Icons.add),
                                  onPressed: () {
                                    vidrios1.add([]);
                                    vidrios2.add([]);
                                    separador.add([]);

                                    if (detallePedidoP.count == 0) {
                                      detallePedidoP.addFila(
                                        vidrioAll.first.toString(),
                                        vidrioAll.first.toString(),
                                        separadorAll.first.toString(),
                                      );
                                    } else {
                                      detallePedidoP.addFila(
                                        detallePedidoP.currentvalueV1[
                                            detallePedidoP.count - 1],
                                        detallePedidoP.currentvalueV2[
                                            detallePedidoP.count - 1],
                                        detallePedidoP.currentvalueS[
                                            detallePedidoP.count - 1],
                                      );
                                    }

                                    if (detallePedidoP.count == 1) {
                                      vidrios1[detallePedidoP.count - 1].insert(
                                          0,
                                          detallePedidoP.currentvalueV1[
                                              detallePedidoP.count - 1]);
                                      vidrios2[detallePedidoP.count - 1].insert(
                                          0,
                                          detallePedidoP.currentvalueV2[
                                              detallePedidoP.count - 1]);
                                      separador[detallePedidoP.count - 1]
                                          .insert(
                                              0,
                                              detallePedidoP.currentvalueS[
                                                  detallePedidoP.count - 1]);

                                      for (var item in separadorAll) {
                                        separador[detallePedidoP.count - 1]
                                            .insert(1, item);
                                      }
                                      for (var item in vidrioAll) {
                                        vidrios2[detallePedidoP.count - 1]
                                            .insert(1, item);
                                        vidrios1[detallePedidoP.count - 1]
                                            .insert(1, item);
                                      }
                                    } else {
                                      vidrios1[detallePedidoP.count - 1].insert(
                                          0,
                                          detallePedidoP.currentvalueV1[
                                              detallePedidoP.count - 2]);

                                      vidrios2[detallePedidoP.count - 1].insert(
                                          0,
                                          detallePedidoP.currentvalueV2[
                                              detallePedidoP.count - 2]);
                                      separador[detallePedidoP.count - 1]
                                          .insert(
                                              0,
                                              detallePedidoP.currentvalueS[
                                                  detallePedidoP.count - 2]);

                                      for (var item in vidrioAll) {
                                        vidrios1[detallePedidoP.count - 1]
                                            .insert(1, item);
                                        vidrios2[detallePedidoP.count - 1]
                                            .insert(1, item);
                                      }

                                      for (var item in separadorAll) {
                                        separador[detallePedidoP.count - 1]
                                            .insert(1, item);
                                      }
                                    }

                                  valor(detallePedidoP.count - 1);
                                  })),
                          Container(
                            margin: const EdgeInsets.only(right: 3),
                            child: SizedBox(
                              height: 50,
                              width: 100,
                              child: TextFormField(
                                  controller: detallePedidoP.controllerTotal,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Total")),
                            ),
                          ),
                        ],
                      ),
                      Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[ 
                        Container(),
                        Column(
                         
                          children: [
                            Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      
                      
                                      detallePedidoP.agregarDetalle();
                      
                                      final pedido = Pedido(
                                        icodigo: detallePedidoP.controllerCodigos.text,
                                          identificador: detallePedidoP
                                              .controllerIdentificador.text,
                                          fecha: DateTime.now(),
                                          detallePedido: detallePedidoP.detalle,
                                          total: double.parse(detallePedidoP
                                              .controllerTotal.text),
                                          usuario: detallePedidoP
                                              .controllerIdentificador.text);
                      
                                      pedidoP.addPedido(pedido);
                                      // presupuestoP.addPresupuesto(pedido);
                      
                                      detallePedidoP.controllerAlto = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerLargo = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerCantidad = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerCodigo = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerCodigos.clear();
                                      detallePedidoP.controllerIdentificador
                                          .clear();
                                      detallePedidoP.controllerM2 = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerValorM2 = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerTotal.clear();
                                      detallePedidoP.controllerPrecio = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.currentvalueS = [
                                        "currentValueS"
                                      ];
                                      detallePedidoP.currentvalueV1 = [
                                        "currentValueV1"
                                      ];
                                      detallePedidoP.currentvalueV2 = [
                                        "currentValueV2"
                                      ];
                                      detallePedidoP.altura = 1;
                                      detallePedidoP.alturaS = 8;
                      
                                      detallePedidoP.count = 0;
                                      detallePedidoP.detalle.clear();
                      
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/pedidos',
                                              (Route<dynamic> route) => false);
                                    },
                                    child: const Text(
                                      "                   Guardar Pedido                     ",
                                      
                                      style: TextStyle(fontSize: 20),
                                    ))),
                                     Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      
                      
                                      detallePedidoP.agregarDetalle();
                      
                                      final pedido = Pedido(
                                      
                                        icodigo: detallePedidoP.controllerCodigos.text,
                                          identificador: detallePedidoP
                                              .controllerIdentificador.text,
                                          fecha: DateTime.now(),
                                          detallePedido: detallePedidoP.detalle,
                                          total: double.parse(detallePedidoP
                                              .controllerTotal.text),
                                          usuario: detallePedidoP
                                              .controllerIdentificador.text);
                      
                                      pedidoP.addPedido(pedido);
                                      presupuestoP.addPresupuesto(pedido);
                      
                                      detallePedidoP.controllerAlto = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerLargo = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerCantidad = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerCodigo = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerCodigos.clear();
                                      detallePedidoP.controllerIdentificador
                                          .clear();
                                      detallePedidoP.controllerM2 = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerValorM2 = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.controllerTotal.clear();
                                      detallePedidoP.controllerPrecio = [
                                        TextEditingController()
                                      ];
                                      detallePedidoP.currentvalueS = [
                                        "currentValueS"
                                      ];
                                      detallePedidoP.currentvalueV1 = [
                                        "currentValueV1"
                                      ];
                                      detallePedidoP.currentvalueV2 = [
                                        "currentValueV2"
                                      ];
                                      detallePedidoP.altura = 1;
                                      detallePedidoP.alturaS = 8;
                      
                                      detallePedidoP.count = 0;
                                      detallePedidoP.detalle.clear();
                      
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/pedidos',
                                              (Route<dynamic> route) => false);
                                    },
                                    child: const Text(
                                      "Guardar Pedido / Generar Pesupuesto",
                                      style: TextStyle(fontSize: 20),
                                    )))
                          ],
                        ),
                        
                        ]
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
