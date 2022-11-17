import 'package:flutter/material.dart';
import 'package:termopanelescco/Models/termo.dart';

import 'package:termopanelescco/Providers/termo_provider.dart';



import 'package:termopanelescco/Widgets/WidgetsProductos/tabla_termo_widget.dart';


import '../../Utils/texts_app.dart';

class TermosWidget extends StatefulWidget {
  const TermosWidget({Key? key}) : super(key: key);

  @override
  State<TermosWidget> createState() => _TermosWidgetState();
}

class _TermosWidgetState extends State<TermosWidget> {
  @override
  Widget build(BuildContext context) {
    String currentvalueV1 = "";
    String currentvalueS = "";
    String currentvalueV2 = "";
    final valorController = TextEditingController();

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
                    children: const [
                      
                    ],
                  ),
                ),
                SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          final termo = Termo(
                              vidrio1: currentvalueV1,
                              separador: currentvalueS,
                              vidrio2: currentvalueV2,
                              valor: int.parse(valorController.text));

                          TermoP().addTermo(termo);
                          valorController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text(TextApp.guardar)))
              ],
            ),
          ));
    }

    return ListView(children: [
      Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
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
                      )),
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
    ]);
  }
}
