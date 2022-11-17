
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetallePedido with ChangeNotifier {
  String? id;
  final String? codigo;
  final String? vidrio1;
  final String? separador;
  final String? vidrio2;
  final int? largo;
  final int? alto;
  final int? cantidad;
  final double? m2;
  final int? valorM2;
  final double? precio;

  DetallePedido({
    this.id,
    required this.codigo,
    required this.vidrio1,
    required this.separador,
    required this.vidrio2,
    required this.largo,
    required this.alto,
    required this.cantidad,
    required this.m2,
    required this.valorM2,
    required this.precio,
  });

  factory DetallePedido.fromJson(Map<dynamic, dynamic> json) => DetallePedido(
      alto: json['alto'],
      cantidad: json['cantidad'],
      codigo: json['codigo'],
      largo: json['largo'],
      m2:json['m2'],
      precio: json['precio'],
      separador:json['separador'],
      valorM2: json['valorM2'],
      vidrio1: json['vidrio1'],
      vidrio2: json['vidrio2']);

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "vidrio1": vidrio1,
        "separador": separador,
        "vidrio2": vidrio2,
        "largo": largo,
        "alto": alto,
        "cantidad": cantidad,
        "m2": m2,
        "valorM2": valorM2,
        "precio": precio,
      };
}
