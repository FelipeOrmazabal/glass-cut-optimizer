import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termopanelescco/Models/termo.dart';

import 'package:termopanelescco/Providers/termo_provider.dart';


import 'package:termopanelescco/Widgets/WidgetsProductos/tabla_termo_widget.dart';


import '../../Utils/texts_app.dart';
import '../Widgets/appbar_widget.dart';

class TermopanelesScreen extends StatefulWidget {
  const TermopanelesScreen({Key? key}) : super(key: key);

  @override
  State<TermopanelesScreen> createState() => _TermopanelesScreenState();
}

class _TermopanelesScreenState extends State<TermopanelesScreen> {
  @override
  Widget build(BuildContext context) {
     final termosP = Provider.of<TermoP>(context);
 


    Widget addDialog() {
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
                          width: 140,
                          child: TextFormField(
                              controller: termosP.vidrio1Controller,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: TextApp.vidrio1))),
                       SizedBox(
                          height: 100,
                          width: 140,
                          child: TextFormField(
                              controller:  termosP.separadorController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: TextApp.separador))),
                       SizedBox(
                          height: 100,
                          width: 140,
                          child: TextFormField(
                              controller:  termosP.vidrio2Controller,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: TextApp.vidrio2))),
                      SizedBox(
                          height: 100,
                          width: 140,
                          child: TextFormField(
                              controller: termosP.valorController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: TextApp.precio))),
                    ],
                  ),
                ),
                SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          final termo = Termo(
                              vidrio1: termosP.vidrio1Controller.text,
                              separador: termosP.separadorController.text,
                              vidrio2: termosP.vidrio2Controller.text,
                              valor: int.parse(termosP.valorController.text));

                          termosP.addTermo(termo);
                          termosP.valorController.clear();
                          termosP.vidrio1Controller.clear();
                          termosP.separadorController.clear();
                          termosP.vidrio2Controller.clear();
                          Navigator.pop(context);
                        },
                        child: const Text(TextApp.guardar)))
              ],
            ),
          ));
    }

    return Scaffold( appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBarWidget(),
      ),
      body:
       ListView(children: [
        Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 39),
                            child: ElevatedButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return addDialog();
                                },
                              ),
                              child: const Text(
                                TextApp.agregartermopaneles,
                                style: TextStyle(fontSize: 25),
                              ),
                            )), Container(
                          alignment: Alignment.bottomRight,
                          margin: const EdgeInsets.only(top: 39),
                          child: const Text(
                            "Termopaneles",
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
                      child: const TablaTermo(),
                    )
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
