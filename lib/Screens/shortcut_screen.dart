import 'package:flutter/material.dart';

import '../Widgets/appbar_widget.dart';

class ShortcutPage extends StatelessWidget {
  const ShortcutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBarWidget(),
      ),
      body: Center(
        child: Container(
            height: 1000,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondo_app.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/pedidos");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            height: 300,
                            width: 300,
                            child: Image.asset('assets/images/pedido.png')),
                      ),
                    ),
                    Container(
                        color: Colors.white54,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15,
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Text(
                          "Pedidos",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/producciones");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            height: 300,
                            width: 300,
                            child: Image.asset('assets/images/produccion.png')),
                      ),
                    ),
                    Container(
                        color: Colors.white54,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15,
                          left: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Text(
                          "Producción",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/presupuestos");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            height: 300,
                            width: 300,
                            child:
                                Image.asset('assets/images/presupuesto.png')),
                      ),
                    ),
                    Container(
                        color: Colors.white54,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15,
                          left: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: Text(
                          "Presupuesto",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
