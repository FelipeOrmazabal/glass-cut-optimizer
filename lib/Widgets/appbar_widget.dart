import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:termopanelescco/Utils/texts_app.dart';

Future cerrarSession() async {
  await FirebaseAuth.instance.signOut();
}

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
//Verificar usuario log

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(TextApp.tituloAppbar),
      actions: [
        if (user.email == "admin@gmail.com") ...[
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              
              child: const Text(
                "Crear Usuarios",
                style: TextStyle(color: Colors.white),
              )),
              TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pedidos');
              },
              child: const Text(
                TextApp.pedidios,
                style: TextStyle(color: Colors.white),
              )),
              TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/presupuestos');
              },
              child: const Text(
                TextApp.presupuestos,
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/termopaneles');
              },
              child: const Text(
                TextApp.productos,
                style: TextStyle(color: Colors.white),
              )),
        ],
        if (user.email == "asistente@gmail.com" ||
            user.email == "asistente@gmail.com") ...[
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pedidos');
              },
              child: const Text(
                TextApp.pedidios,
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/presupuestos');
              },
              child: const Text(
                TextApp.presupuestos,
                style: TextStyle(color: Colors.white),
              )),
        ],
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/producciones');
            },
            child: const Text(
              TextApp.produccion,
              style: TextStyle(color: Colors.white),
            )),
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Hola " + user.email!),
        )),
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, '/home');
          },
          color: Colors.blueAccent,
          child: Text('Cerrar sesión'),
        ),
      ],
    );
  }
}
