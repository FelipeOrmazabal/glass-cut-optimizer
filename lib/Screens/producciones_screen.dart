import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:termopanelescco/Models/columna.dart';
import 'package:termopanelescco/Models/fila.dart';
import 'package:termopanelescco/Models/plancha.dart';

import 'package:termopanelescco/Models/produccion.dart';

import '../Widgets/appbar_widget.dart';
import 'detalles_produccion_screen.dart';

class ProduccionesScreen extends StatefulWidget {
  const ProduccionesScreen({Key? key}) : super(key: key);

  @override
  State<ProduccionesScreen> createState() => _ProduccionesScreenState();
}

class _ProduccionesScreenState extends State<ProduccionesScreen> {
  Future<List<Produccion>> readProduccion() async {

  

    List<Produccion> itemsProduccion = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("producciones")
        .orderBy("fecha")
        .get();


    for (var element in snapshot.docs) {
      itemsProduccion.insert(
          0,
          Produccion(
            id: element['id'],
            identificador: element["identificador"],
            fecha: (element["fecha"] as Timestamp).toDate(),
            plancha: [
              for (var plancha  in element["plancha"] ) ...[
                Plancha(
                  columna: [ 
                    for (var  columna in plancha["columna"]) ...[
                      Columna(fila: [
                        for (var  fila in columna["fila"]) ...[
                          Fila(
                            codigo: fila["codigo"],
                            estado: fila["estado"],
                            largo: fila["largo"],
                            alto: fila["alto"],
                            cantidad:fila["cantidad"],
                            m2: fila["m2"],
                          )
                        ]
                      ])
                    ]
                  ],
                )
              ],
            ],
            usuario: element["usuario"],
            altoPLancha: element["altoPlancha"],
            largoPlancha: element["largoPlancha"],
          ));
    }

    return itemsProduccion;
  }

  @override
  void initState() {
    readProduccion();
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
                        "Pedidos en Produccion",
                        style: TextStyle(
                            fontSize: 43, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),

                        // import de Widgets/widgetsProductos/tabla_widget
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: FutureBuilder(
                              future: readProduccion(),
                              builder: (context, AsyncSnapshot<List> snapshot) {
                                List producciones = snapshot.data ?? [];
                                return Column(children: [
                                  for (Produccion produccion in producciones)
                                    Card(
                                      color: const Color.fromARGB(
                                          255, 201, 203, 213),
                                      child: ListTile(
                                        subtitle:
                                            Text(produccion.fecha.toString()),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextButton(
                                                onPressed: () {

                                               

                                                  Navigator.of(context).push(
                                                      MaterialPageRoute<void>(
                                                          builder: ((context) {
                                                    
                                                    return DetalleProduccionScreen(
                                                        produccion: produccion);
                                                  })));
                                                },
                                                child: Row(children: const [
                                                  Text(
                                                    "Ver produccion ",
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
                                        title: Text(produccion.identificador
                                            .toString()),
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
