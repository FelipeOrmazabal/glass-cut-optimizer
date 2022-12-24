import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = TextEditingController();
    final password = TextEditingController();
    //Widget popUp() {
    //  return const Dialog(
    //    child: const SizedBox(
    //        height: 150,
    //        width: 300,
    //        child: Center(
    //          child: const Text("Usuaio o Contraseña Incorrecta"),
    //        )),
    //  );
    //}

    Future signIn() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: usuario.text.trim(), password: password.text.trim());
        Navigator.pushNamed(context, "/shortcut");
      } on FirebaseAuthException catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(e.message.toString()),
            );
          },
        );
      }
    }

    //@override
    //void dispose() {
    //  usuario.dispose();
    //  password.dispose();
    //  //super.dispose();
    //}

    return Scaffold(
      body: Center(
          child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: const Color.fromARGB(255, 52, 85, 192)),
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
                        signIn();
                      },
                      child: const Text("Ingresar"))),
              SizedBox(height: 30),
            ],
          ),
        ),
      )),
    );
  }
}
