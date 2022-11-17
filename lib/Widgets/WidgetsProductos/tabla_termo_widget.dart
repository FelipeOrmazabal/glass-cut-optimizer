import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termopanelescco/Models/termo.dart';
import 'package:termopanelescco/Providers/termo_provider.dart';
import 'package:termopanelescco/Utils/texts_app.dart';

class TablaTermo extends StatefulWidget {
  const TablaTermo({Key? key}) : super(key: key);

  @override
  State<TablaTermo> createState() => _TablaTermoState();
}

class _TablaTermoState extends State<TablaTermo> {
  @override
  Widget build(BuildContext context) {
   
   final termosP = Provider.of<TermoP>(context);
    Widget editDialog(Termo termos) {
final controllerVisdrio1 = TextEditingController(text: termos.vidrio1);
final controllerSeparador = TextEditingController(text: termos.separador);
final controllerVisdrio2 = TextEditingController(text: termos.vidrio2);
final controllerValor = TextEditingController( text: termos.valor.toString() );

      return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 690,
            height: 250,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const ListTile(
                  title: Text(
                    TextApp.agregartermopanel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 160,
                        child: Container(
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            child: TextFormField(
                              controller: controllerVisdrio1,
                                enabled: false,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: TextApp.vidrio1))),
                      ),
                      SizedBox(
                        height: 100,
                        width: 160,
                        child: Container(
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            child: TextFormField(
                              controller: controllerSeparador,
                                enabled: false,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: TextApp.separador))),
                      ),
                      SizedBox(
                        height: 100,
                        width: 160,
                        child: Container(
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            child: TextFormField(
                              controller: controllerVisdrio2,
                                enabled: false,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: TextApp.vidrio2))),
                      ),
                      SizedBox(
                          height: 100,
                          width: 130,
                          child: Container(
                            
                             padding: const EdgeInsets.only(bottom: 15, top: 15),
                            child: TextFormField(
                              controller: controllerValor,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: TextApp.valor)),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                         
                           final termo = Termo(id: termos.id, valor: int.parse(controllerValor.text) );
                          termosP.edit(termo);
                          Navigator.pop(context);
                        },
                        child: const Text(TextApp.guardar)))
              ],
            ),
          ));
    }

    return StreamBuilder<List<Termo>>(
      stream: TermoP().read(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("wad");
        } else if (snapshot.hasData) {
          final data = snapshot.data;

          if (data == null) {
            return const Center(child: Text('No existen Vidrios'));
          } else {
            return DataTable(
                showCheckboxColumn: false,
                sortColumnIndex: 0,
                onSelectAll: (value) {},
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      TextApp.vidrio1,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      TextApp.separador,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      TextApp.vidrio2,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      TextApp.valor,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "editar",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "eliminar",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: data
                    .map((e) => DataRow(cells: [
                          DataCell(
                              SizedBox(width: 70, child: Text("${e.vidrio1}"))),
                          DataCell(SizedBox(
                              width: 70, child: Text("${e.separador}"))),
                          DataCell(
                              SizedBox(width: 70, child: Text("${e.vidrio2}"))),
                          DataCell(
                              SizedBox(width: 50, child: Text(" ${e.valor}"))),
                          DataCell(IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    
                                    final termo1 = Termo(
                                         id: e.id,
                                        vidrio1: e.vidrio1,
                                        separador: e.separador,
                                        vidrio2: e.vidrio2,
                                        valor:  int.parse(e.valor.toString())  );

                                    return editDialog(termo1);
                                  },
                                );
                              })),
                          DataCell(IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                TermoP().delete(e.id.toString());
                              })),
                        ]))
                    .toList());
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
