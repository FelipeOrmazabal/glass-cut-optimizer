import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termopanelescco/Models/detalle_pedido.dart';

import 'package:termopanelescco/Models/pedido.dart';
import 'package:termopanelescco/Providers/presupuesto_provider.dart';

import '../Models/columna.dart';
import '../Models/fila.dart';
import '../Models/plancha.dart';
import '../Models/produccion.dart';
import '../Models/termo.dart';
import '../Providers/detalle_pedido_provider.dart';
import '../Providers/pedido_provider.dart';
import '../Providers/produccion_provider.dart';
import '../Utils/texts_app.dart';
import '../Widgets/appbar_widget.dart';

class DetallePedidoScreen extends StatefulWidget {
  const DetallePedidoScreen({Key? key, required this.pedido}) : super(key: key);

  final Pedido pedido;

  @override
  State<DetallePedidoScreen> createState() => _DetallePedidoScreenState();
}

class _DetallePedidoScreenState extends State<DetallePedidoScreen> {
  List<Termo> termos = [];
  List<String> vidrioAll = [];
  List<String> separadorAll = [];
 final controllerLargo = TextEditingController();
  final controllerAlto = TextEditingController();
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
   int i = 0;

  @override
  Widget build(BuildContext context) {
    final dPP = Provider.of<DetallePedidoP>(context);
    final pedidoP = Provider.of<PedidoP>(context);
    final presupuestoP = Provider.of<PresupuestoP>(context);

    void valor(int index) {
      dPP.controllerValorM2[index].text = 27000.toString();
      for (var item in termos) {
        if (dPP.currentvalueV1[index] == item.vidrio1 &&
                dPP.currentvalueS[index] == item.separador &&
                dPP.currentvalueV2[index] == item.vidrio2 ||
            dPP.currentvalueV2[index] == item.vidrio1 &&
                dPP.currentvalueS[index] == item.separador &&
                dPP.currentvalueV1[index] == item.vidrio2) {
          dPP.controllerValorM2[index].text = item.valor.toString();
        }
      }
    }

    Pedido? pedido = widget.pedido;
    List<DetallePedido> dpedido = pedido.detallePedido as List<DetallePedido>;
    
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
                                    estado: false,
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
                              if (i == 0) {
                                alto += filaO[i].alto as num;
                              }

                              largo += filaO[i].largo as num;
                              if (largo > int.parse(controllerLargo.text)) {
                                alto += filaO[i].alto as num;
                              }

                              if (largo <= int.parse(controllerLargo.text) &&
                                  alto <= int.parse(controllerAlto.text)) {
                                fil[lfila].insert(
                                    0,
                                    Fila(
                                      estado: false,
                                      codigo: filaO[i].codigo,
                                      largo: filaO[i].largo,
                                      alto: filaO[i].alto,
                                      cantidad: filaO[i].cantidad,
                                      m2: filaO[i].m2,
                                    ));
                              } else if (alto >
                                  int.parse(controllerAlto.text)) {
                                alto = filaO[i].alto as double;
                                largo = filaO[i].largo as double;
                                colu[lcol].insert(0, Columna(fila: fil[lfila]));
                                pla.insert(0, Plancha(columna: colu[lcol]));
                                lcol = lcol + 1;
                                colu.add([]);
                                fil.add([]);
                                lfila = lfila + 1;

                                fil[lfila].insert(
                                    0,
                                    Fila(
                                      estado: false,
                                      codigo: filaO[i].codigo,
                                      largo: filaO[i].largo,
                                      alto: filaO[i].alto,
                                      cantidad: filaO[i].cantidad,
                                      m2: filaO[i].m2,
                                    ));
                              } else if (largo >
                                  int.parse(controllerLargo.text)) {
                                largo = filaO[i].largo as double;

                                colu[lcol].insert(0, Columna(fila: fil[lfila]));
                                lfila = lfila + 1;
                                fil.add([]);

                                fil[lfila].insert(
                                    0,
                                    Fila(
                                      estado: false,
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

                          ProduccionP().addProduccion(pedidoProduccion);

                         controllerAlto.text = "";
                          controllerLargo.text = "";
                          Navigator.pushNamed(context, "/producciones");
                        },
                        child: const Text("Enviar a Produccion")))
              ],
            ),
          ));
    }
    
    if (dPP.vista == false) {
      return Scaffold(
        // Import de widgets/appbar_widget (para importar appbar requiere PreferredSize)
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarWidget(),
        ),

        body: ListView(children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.68,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 20),
                      child: const Text(
                        "Detalles Del Pedido",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: SizedBox(
                            height: 50,
                            child: Text(
                              "Identificador:   ${pedido.identificador.toString()}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: SizedBox(
                            height: 50,
                            child: Text("Fecha:   ${pedido.fecha.toString()}"),
                          ),
                        ),
                      ]),
                  DataTable(
                      showCheckboxColumn: false,
                      sortColumnIndex: 0,
                      onSelectAll: (value) {},
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            "Codigo",
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            TextApp.vidrio1,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            TextApp.separador,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            TextApp.vidrio2,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "largo mm",
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "alto mm",
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "cantidad",
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "M^2",
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Valor M^2",
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "precio",
                          ),
                        ),
                      ],
                      rows: pedido.detallePedido!
                          .map((e) => DataRow(cells: [
                                DataCell(SizedBox(child: Text("${e.codigo}"))),
                                DataCell(SizedBox(child: Text("${e.vidrio1}"))),
                                DataCell(SizedBox(child: Text("${e.separador}"))),
                                DataCell(SizedBox(child: Text(" ${e.vidrio2}"))),
                                DataCell(SizedBox(child: Text(" ${e.largo}"))),
                                DataCell(SizedBox(child: Text(" ${e.alto}"))),
                                DataCell(SizedBox(child: Text(" ${e.cantidad}"))),
                                DataCell(SizedBox(child: Text(" ${e.m2}"))),
                                DataCell(SizedBox(child: Text(" ${e.valorM2}"))),
                                DataCell(SizedBox(child: Text(" ${e.precio}"))),
                              ]))
                          .toList()),
                  const Divider(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.bottomRight, child: Container()),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                child: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    dPP.vista = true;
                                  });
                                })),
                        Container(
                          margin: const EdgeInsets.only(right: 3),
                          child: SizedBox(
                            height: 50,
                            width: 100,
                            child: Text("Total: ${pedido.total.toString()}"),
                          ),
                        ),
                      ],
                    ),
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
                                        presupuestoP.addPresupuesto(pedido);

                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil('/presupuestos',
                                                (Route<dynamic> route) => false);
                                      },
                                      child: const Text(
                                        "Generar presupuesto",
                                        
                                        style: TextStyle(fontSize: 20),
                                      ))),
                                       Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: ElevatedButton(
                                      onPressed: () => showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return enviarProduccion(
                                                            pedido);
                                                      },
                                                    ),
                                      child: const Text(
                                        " Enviar a pruduccion ",
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
        ]),
      );
    } else {


     
        if (i==0){
          dPP.controllerIdentificador.text = pedido.identificador.toString();
            dPP.controllerTotal.text = pedido.total.toString();
            dPP.controllerCodigos.text = pedido.icodigo.toString();
        
      for (var item in dpedido) {
      
        vidrios1.add([]);
        vidrios2.add([]);
        separador.add([]);

        dPP.addFila2(
          
            item.vidrio1.toString(),
            item.vidrio2.toString(),
            item.separador.toString(),
            item.codigo.toString(),
            item.largo.toString(),
            item.alto.toString(),
            item.cantidad.toString(),
            item.m2.toString(),
            item.valorM2.toString(),
            item.precio.toString());

        vidrios1[i].insert(0, item.vidrio1.toString());
        vidrios2[i].insert(0, item.vidrio2.toString());
        separador[i].insert(0, item.separador.toString());

        for (var item in separadorAll) {
          separador[i].insert(1, item);
        }
        for (var item in vidrioAll) {
          vidrios2[i].insert(1, item);
          vidrios1[i].insert(1, item);
        }
        i++;
      }
    }}


      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // Import de widgets/appbar_widget (para importar appbar requiere PreferredSize)
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/pedidos', (Route<dynamic> route) => false);
                dPP.controllerAlto = [];
                dPP.controllerLargo = [];
                dPP.controllerCantidad = [];
                dPP.controllerCodigo = [];
                dPP.controllerCodigos.clear();
                dPP.controllerIdentificador.clear();
                dPP.controllerM2 = [];
                dPP.controllerValorM2 = [];
                dPP.controllerTotal.clear();
                dPP.controllerPrecio = [];
                dPP.currentvalueS = [];
                dPP.currentvalueV1 = [];
                dPP.currentvalueV2 = [];
                dPP.altura = 1;
                dPP.alturaS = 8;
                dPP.vista = false;
                dPP.count = 0;
                dPP.detalle.clear();
              },
            ),
            title: const Text(TextApp.tituloAppbar),
            
          ),
          body: ListView(children: [
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 68 * dPP.alturaS,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 30, bottom: 20),
                            child: const Text(
                              "Editar Pedido",
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
                                    controller: dPP.controllerCodigos,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Codigo")),
                              ),
                              //cambio
                              SizedBox(
                                height: 50,
                                width: 500,
                                child: TextFormField(
                                    controller: dPP.controllerIdentificador,
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
                            height: 68 * dPP.altura,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ListView.separated(
                              itemCount: dPP.count,
                              itemBuilder: (BuildContext context, int index) {
                                dPP.codigos(dPP.controllerCodigos.text);
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 80,
                                      child: TextFormField(
                                          controller:
                                              dPP.controllerCodigo[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          )),
                                    ),
                                    SizedBox(
                                        height: 50,
                                        width: 160,
                                        child: DropdownButtonFormField(
                                            value: vidrios1[index]
                                                .first
                                                .toString(),
                                            items: vidrios1[index]
                                                .toSet()
                                                .map(
                                                    (items) => DropdownMenuItem(
                                                          child: Text(items),
                                                          value: items,
                                                        ))
                                                .toList(),
                                            onChanged: (value) {
                                              dPP.currentvalueV1[index] =
                                                  value.toString();
                                              valor(index);
                                              if (dPP.controllerM2[index]
                                                      .text !=
                                                  "") {
                                                dPP.precio(index);
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ))),
                                    SizedBox(
                                        height: 50,
                                        width: 170,
                                        child: DropdownButtonFormField(
                                            value: separador[index]
                                                .first
                                                .toString(),
                                            items: separador[index]
                                                .toSet()
                                                .map(
                                                    (items) => DropdownMenuItem(
                                                          child: Text(items),
                                                          value: items,
                                                        ))
                                                .toList(),
                                            onChanged: (value) {
                                              dPP.currentvalueS[index] =
                                                  value.toString();
                                              valor(index);
                                              if (dPP.controllerM2[index]
                                                      .text !=
                                                  "") {
                                                dPP.precio(index);
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ))),
                                    SizedBox(
                                        height: 50,
                                        width: 160,
                                        child: DropdownButtonFormField(
                                            value: vidrios2[index]
                                                .first
                                                .toString(),
                                            items: vidrios2[index]
                                                .toSet()
                                                .map(
                                                    (items) => DropdownMenuItem(
                                                          child: Text(items),
                                                          value: items,
                                                        ))
                                                .toList(),
                                            onChanged: (value) {
                                              dPP.currentvalueV2[index] =
                                                  value.toString();
                                              valor(index);
                                              if (dPP.controllerM2[index]
                                                      .text !=
                                                  "") {
                                                dPP.precio(index);
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
                                            dPP.m2(index);
                                          },
                                          controller:
                                              dPP.controllerLargo[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 120,
                                      child: TextFormField(
                                          onChanged: (value) {
                                            dPP.m2(index);
                                          },
                                          controller: dPP.controllerAlto[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 100,
                                      child: TextFormField(
                                          onChanged: (value) {
                                            dPP.precio(index);
                                          },
                                          controller:
                                              dPP.controllerCantidad[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 80,
                                      child: TextFormField(
                                          onChanged: (value) {
                                            dPP.precio(index);
                                          },
                                          controller: dPP.controllerM2[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 100,
                                      child: TextFormField(
                                          onChanged: (value) {
                                            dPP.total();
                                            dPP.precio(index);
                                          },
                                          controller:
                                              dPP.controllerValorM2[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 100,
                                      child: TextFormField(
                                          onChanged: (value) {
                                            dPP.total();
                                          },
                                          controller:
                                              dPP.controllerPrecio[index],
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
                                    dPP.deleteFila();
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

                                         if (dPP.count == 0) {
                                      dPP.addFila(
                                        vidrioAll.first.toString(),
                                        vidrioAll.first.toString(),
                                        separadorAll.first.toString(),
                                      );
                                    } else {
                                      
                                      dPP.addFila(
                                        dPP.currentvalueV1[
                                            dPP.count - 1],
                                        dPP.currentvalueV2[
                                            dPP.count - 1],
                                        dPP.currentvalueS[
                                            dPP.count - 1],
                                      );
                                    }

                                    if (dPP.count == 1) {
                                      vidrios1[dPP.count - 1].insert(
                                          0,
                                          dPP.currentvalueV1[
                                              dPP.count - 1]);
                                      vidrios2[dPP.count - 1].insert(
                                          0,
                                          dPP.currentvalueV2[
                                              dPP.count - 1]);
                                      separador[dPP.count - 1]
                                          .insert(
                                              0,
                                              dPP.currentvalueS[
                                                  dPP.count - 1]);

                                      for (var item in separadorAll) {
                                        separador[dPP.count - 1]
                                            .insert(1, item);
                                      }
                                      for (var item in vidrioAll) {
                                        vidrios2[dPP.count - 1]
                                            .insert(1, item);
                                        vidrios1[dPP.count - 1]
                                            .insert(1, item);
                                      }
                                    } else {
                                      vidrios1[dPP.count - 1].insert(
                                          0,
                                          dPP.currentvalueV1[
                                              dPP.count - 2]);

                                      vidrios2[dPP.count - 1].insert(
                                          0,
                                          dPP.currentvalueV2[
                                              dPP.count - 2]);
                                      separador[dPP.count - 1]
                                          .insert(
                                              0,
                                              dPP.currentvalueS[
                                                  dPP.count - 2]);

                                      for (var item in vidrioAll) {
                                        vidrios1[dPP.count - 1]
                                            .insert(1, item);
                                        vidrios2[dPP.count - 1]
                                            .insert(1, item);
                                      }

                                      for (var item in separadorAll) {
                                        separador[dPP.count - 1]
                                            .insert(1, item);
                                      }
                                    }


                                      
                                       valor(dPP.count - 1);
                                     
                                    })),
                            Container(
                              margin: const EdgeInsets.only(right: 3),
                              child: SizedBox(
                                height: 50,
                                width: 100,
                                child: TextFormField(
                                    controller: dPP.controllerTotal,
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
                                      dPP.delete(pedido.id.toString());
                      
                                      dPP.agregarDetalle();
                      
                                      final pedidoad = Pedido(
                                        icodigo: dPP.controllerCodigos.text,
                                          identificador: dPP
                                              .controllerIdentificador.text,
                                          fecha: DateTime.now(),
                                          detallePedido: dPP.detalle,
                                          total: double.parse(dPP
                                              .controllerTotal.text),
                                          usuario: dPP
                                              .controllerIdentificador.text);
                      
                                      pedidoP.addPedido(pedidoad);
                                      // presupuestoP.addPresupuesto(pedido);
                      
                                      dPP.controllerAlto = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerLargo = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerCantidad = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerCodigo = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerCodigos.clear();
                                      dPP.controllerIdentificador
                                          .clear();
                                      dPP.controllerM2 = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerValorM2 = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerTotal.clear();
                                      dPP.controllerPrecio = [
                                        TextEditingController()
                                      ];
                                      dPP.currentvalueS = [
                                        "currentValueS"
                                      ];
                                      dPP.currentvalueV1 = [
                                        "currentValueV1"
                                      ];
                                      dPP.currentvalueV2 = [
                                        "currentValueV2"
                                      ];
                                      dPP.altura = 1;
                                      dPP.alturaS = 8;
                      
                                      dPP.count = 0;
                                      dPP.detalle.clear();
                                       dPP.vista = false;
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/pedidos',
                                              (Route<dynamic> route) => false);
                                    },
                                    child: const Text(
                                      "   Guardar Cambios   ",
                                      
                                      style: TextStyle(fontSize: 20),
                                    ))),
                                     Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      
                      
                                      dPP.agregarDetalle();
                      
                                      final pedido = Pedido(
                                        icodigo: dPP.controllerCodigos.text,
                                          identificador: dPP
                                              .controllerIdentificador.text,
                                          fecha: DateTime.now(),
                                          detallePedido: dPP.detalle,
                                          total: double.parse(dPP
                                              .controllerTotal.text),
                                          usuario: dPP
                                              .controllerIdentificador.text);
                      
                                      pedidoP.addPedido(pedido);
                                      
                      
                                      dPP.controllerAlto = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerLargo = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerCantidad = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerCodigo = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerCodigos.clear();
                                      dPP.controllerIdentificador
                                          .clear();
                                      dPP.controllerM2 = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerValorM2 = [
                                        TextEditingController()
                                      ];
                                      dPP.controllerTotal.clear();
                                      dPP.controllerPrecio = [
                                        TextEditingController()
                                      ];
                                      dPP.currentvalueS = [
                                        "currentValueS"
                                      ];
                                      dPP.currentvalueV1 = [
                                        "currentValueV1"
                                      ];
                                      dPP.currentvalueV2 = [
                                        "currentValueV2"
                                      ];
                                      dPP.altura = 1;
                                      dPP.alturaS = 8;
                      
                                      dPP.count = 0;
                                      dPP.detalle.clear();

                                      dPP.vista = false;
                      
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/pedidos',
                                              (Route<dynamic> route) => false);
                                    },
                                    child: const Text(
                                      "Guardar como nuevo",
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

