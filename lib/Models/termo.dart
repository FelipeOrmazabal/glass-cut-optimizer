import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';



class Termo with ChangeNotifier {
  String? id;
  final String? vidrio1;
  final String? separador;
  final String? vidrio2;
  final int? valor;

  Termo({this.id = "",  this.vidrio1, this.separador,
    this.vidrio2,required this.valor,
});



  factory Termo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Termo(
      id: data?['id'],
      vidrio1: data?['vidrio1'],
      separador: data?['separador'],
        vidrio2: data?['vidrio2'],
         valor: data?['valor'],

    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (vidrio1 != null) "vidrio1": vidrio1,
      if (separador != null) "separador": separador,
       if (vidrio2 != null) "vidrio2": vidrio2,
        if (valor != null) "valor": valor,
    };
  }

  static Termo fromfirestore(Map<String, dynamic> json) => Termo(
      id: json['id'], vidrio1: json['vidrio1'], separador: json['separador'], vidrio2: json['vidrio2'], valor: json['valor'],);
}






