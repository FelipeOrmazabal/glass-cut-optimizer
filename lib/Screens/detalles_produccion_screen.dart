import 'package:flutter/material.dart';


import 'package:termopanelescco/Models/produccion.dart';

import '../Widgets/appbar_widget.dart';

class DetalleProduccionScreen extends StatefulWidget {
  const DetalleProduccionScreen({Key? key, required this.produccion})
      : super(key: key);

  final Produccion produccion;

  @override
  State<DetalleProduccionScreen> createState() =>
      _DetalleProduccionScreenState();
}

class _DetalleProduccionScreenState extends State<DetalleProduccionScreen> {
  @override
  Widget build(BuildContext context) {
    Produccion? produccion = widget.produccion;

    return Scaffold(
      // Import de widgets/appbar_widget (para importar appbar requiere PreferredSize)
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBarWidget(),
      ),

      body: Column(children: [
        Column(children: [
          Center(
            child: Container(
              color: Colors.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            child: Text(
                              "Produccion: ${produccion.identificador} ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: SizedBox(
                            child:
                                Text("Fecha:   ${produccion.fecha.toString()}"),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ]),
        Expanded(
            child: ListView(scrollDirection: Axis.horizontal, children: 
       
             produccion.plancha
                  ?.map(
                    (plancha) => Stack(
                      children:[ Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1)),
                        margin: const EdgeInsets.only(
                            left: 60, right: 60, bottom: 60, top: 30),
                        child: SizedBox(
                          height: produccion.altoPLancha / 3,
                          width: produccion.largoPlancha / 3 + 8,
                          child: Column(
                              children: plancha.columna
                                  .map(
                                    (columna) => Row(
                                      children: columna.fila
                                          .map(
                                            (fila) => Stack(children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1)),
                                                child:  SizedBox(
                                                  height: fila.altoV as double,
                                                  width: fila.largoV as double,
                                                  child: Center(
                                                    child: Container(
                                                      color: const Color.fromARGB(255, 235, 235, 235),
                                                      child: Column(children: [
                                                        Text(fila.largo.toString()),
                                                        
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                             
                                                              children: [
                                                                Container( margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, ), child: Text(fila.alto.toString()))
                                                                    ,Container( margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, ), child: Text(fila.codigo.toString(), style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.bold), ))
                                                                  ,  Container( )
                                                              ],
                                                            )
                                                    
                                                      ],),
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          )
                                          .toList(),
                                    ),
                                  )
                                  .toList()
                    
                              //
                              //row
                              //
                    
                              //
                    
                              //Row
                              //
                    
                              ),
                        ),
                      ),]
                    )
                  )
                  .toList() as List<Widget>

              // [

              //   //
              //   //Plancha
              //   //

              //    TextButton(
              //             onPressed: () {

              //                 for (var item in produccion.plancha as List<Plancha>) {

              //                 for (var item2 in item.columna as List<Columna>) {

              //                   print(item2.fila.length);

              //                 }
              //                 }

              //             },
              //             child: Text("lala"),
              //           ),
              // ]
          
          //Plancha
          //

          //
          //
       ))
      ]),
    );
  }
}
