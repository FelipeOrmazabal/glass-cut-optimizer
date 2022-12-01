// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

import '../Widgets/appbar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = TextEditingController();
    final password = TextEditingController();
    Widget popUp() {
      return const Dialog(
        child: const SizedBox(
            height: 150,
            width: 300,
            child: Center(
              child: const Text("Usuaio o Contraseña Incorrecta"),
            )),
      );
    }

    return Scaffold(
      // Import de widgets/appbar_widget (para importar appbar requiere PreferredSize)
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: const AppBarWidget(),
      ),

      body: Center(
          child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: Color.fromARGB(255, 52, 85, 192)),
        ),
        child: SizedBox(
          width: 400,
          height: 400,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const ListTile(
                title: Text(
                  "Bienvenido Inicia Sesion",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.person),
                  Text("   Usuario"),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: TextField(
                      controller: usuario,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ))),
              Row(
                children: const [
                  Icon(Icons.lock),
                  Text("   Contraseña"),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 50,
                  ),
                  child: TextFormField(
                      obscureText: true,
                      controller: password,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ))),
              SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        if (password.text == "leica666" &&
                            usuario.text == "admin") {
                          Navigator.pushNamed(context, "/pedidos");
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return popUp();
                              });
                        }
                      },
                      child: const Text("Ingresar")))
            ],
          ),
        ),
      )),
    );
  }
}
