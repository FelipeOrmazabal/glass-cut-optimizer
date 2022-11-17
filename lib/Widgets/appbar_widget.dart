import 'package:flutter/material.dart';

import 'package:termopanelescco/Utils/texts_app.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
    
       
      title: const Text(TextApp.tituloAppbar),
      actions: [
        TextButton(onPressed: ()  { Navigator.pushNamed(context, '/pedidos');}, child: const Text(TextApp.pedidios,style: TextStyle(color: Colors.white),)),
         TextButton(onPressed: () { Navigator.pushNamed(context, '/presupuestos');}, child: const Text(TextApp.presupuestos,style: TextStyle(color: Colors.white),)),
          TextButton(onPressed: () {Navigator.pushNamed(context, '/producciones');}, child: const Text(TextApp.produccion,style: TextStyle(color: Colors.white),)),
     
           
         
           TextButton(onPressed: () {
            Navigator.pushNamed(context, '/termopaneles');

           },
           
           
            child: const Text(TextApp.productos,style: TextStyle(color: Colors.white),)),
           
      ],
    );
  }
}
