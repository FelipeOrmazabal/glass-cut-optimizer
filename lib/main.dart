import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:termopanelescco/Providers/agregar_detalle_pedido_provider.dart';
import 'package:termopanelescco/Providers/detalle_pedido_provider.dart';
import 'package:termopanelescco/Providers/detalle_produccion_provider.dart';
import 'package:termopanelescco/Providers/pedido_provider.dart';
import 'package:termopanelescco/Providers/presupuesto_provider.dart';
import 'package:termopanelescco/Screens/agregar_pedido_screen.dart';

import 'package:termopanelescco/Screens/home_screen.dart';
import 'package:termopanelescco/Screens/pedidos_screen.dart';
import 'package:termopanelescco/Screens/presupuestos_screen.dart';
import 'package:termopanelescco/Screens/producciones_screen.dart';
import 'package:termopanelescco/Screens/termopaneles_screen.dart';

import 'Providers/termo_provider.dart';
import 'Screens/register_screen.dart';
import 'Screens/shortcut_screen.dart';

Future main() async {
//Coneccion a Firestore

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //datos de coneccion
      options: const FirebaseOptions(
    apiKey: "AIzaSyASVHU2Uyv1qmRlKmTbEfxBuiTP9ijMQ7I",
    authDomain: "glowing-service-368612.firebaseapp.com",
    projectId: "glowing-service-368612",
    storageBucket: "glowing-service-368612.appspot.com",
    messagingSenderId: "383193845980",
    appId: "1:383193845980:web:11797bf5fa42e3234aa419",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TermoP()),
        ChangeNotifierProvider(create: (_) => AgregarDetallePedidoP()),
        ChangeNotifierProvider(create: (_) => PedidoP()),
        ChangeNotifierProvider(create: (_) => PresupuestoP()),
        ChangeNotifierProvider(create: (_) => DetalleProduccionP()),
        ChangeNotifierProvider(create: (_) => DetallePedidoP()),
        ChangeNotifierProvider(create: (_) => AgregarDetallePedidoP()),
      ],
      child: MaterialApp(
        title: 'Termopanelescco',
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color.fromARGB(255, 96, 139, 127)),

        initialRoute: '/',
        //rutas de Screens de APP
        routes: {
          '/home': (context) => const HomeScreen(),
          '/register': (context) => const RegisterScreen(),
          '/termopaneles': (context) => const TermopanelesScreen(),
          '/pedidos': (context) => const PedidosScreen(),
          '/pedidos/agregarpedido': (context) => const AgregarPedidoScreen(),
          '/presupuestos': (context) => const PresupuestosScreen(),
          '/producciones': (context) => const ProduccionesScreen(),
          '/shortcut': (context) => const ShortcutPage(),
        },
        home: StreamBuilder<User?>(builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return PedidosScreen();
          } else {
            return HomeScreen();
          }
        })),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
