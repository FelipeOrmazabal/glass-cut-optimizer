import 'package:flutter/material.dart';

import 'package:termopanelescco/Models/pedido.dart';

import '../Utils/texts_app.dart';
import '../Widgets/appbar_widget.dart';

class DetallePedidoScreen extends StatefulWidget {
  const DetallePedidoScreen({Key? key, required this.pedido}) : super(key: key);

final Pedido pedido;

  @override
  State<DetallePedidoScreen> createState() => _DetallePedidoScreenState();
}

class _DetallePedidoScreenState extends State<DetallePedidoScreen> {
  @override
  Widget build(BuildContext context) {
    Pedido? pedido = widget.pedido;
   
//prueba 2
    return Scaffold(
      // Import de widgets/appbar_widget (para importar appbar requiere PreferredSize)
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBarWidget(),
      ),

      body: ListView(children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 20),
                  child: const Text(
                    "Detalles Del Pedido",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
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
                        child: Text(
                            "Fecha:   ${pedido.fecha.toString()}"),
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
                              DataCell(
                                  SizedBox(child: Text("${e.codigo}"))),
                              DataCell(
                                  SizedBox(child: Text("${e.vidrio1}"))),
                              DataCell(SizedBox(
                                  child: Text("${e.separador}"))),
                              DataCell(
                                  SizedBox(child: Text(" ${e.vidrio2}"))),
                              DataCell(
                                  SizedBox(child: Text(" ${e.largo}"))),
                              DataCell(
                                  SizedBox(child: Text(" ${e.alto}"))),
                              DataCell(SizedBox(
                                  child: Text(" ${e.cantidad}"))),
                              DataCell(SizedBox(child: Text(" ${e.m2}"))),
                              DataCell(
                                  SizedBox(child: Text(" ${e.valorM2}"))),
                              DataCell(
                                  SizedBox(child: Text(" ${e.precio}"))),
                            ]))
                        .toList()),
              
              const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          heroTag: "caca",
                          child: const Icon(Icons.delete),
                          onPressed: () {
                     
                          }),
                    ),
                    Container(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            child: const Icon(Icons.add),
                            onPressed: () {
                        
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
             
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 20,right: 150),
                      child: ElevatedButton(
                          onPressed: () {
                           
                          },
                          child: const Text(
                            "Guardar",
                            style: TextStyle(fontSize: 20),
                          ))),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
