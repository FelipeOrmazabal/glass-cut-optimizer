import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Fila with ChangeNotifier {
  String? id;
  final String? codigo;
  final int? largo;
  final int? alto;

  final int? cantidad;
  final double? m2;

  Fila({
    this.id,
    required this.codigo,
    required this.largo,
    required this.alto,
    required this.cantidad,
    required this.m2,
  });

  factory Fila.fromJson(Map<dynamic, dynamic> json) => Fila(
        alto: json['alto'],
        cantidad: json['cantidad'],
        codigo: json['codigo'],
        largo: json['largo'],
        m2: json['m2'],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "largo": largo,
        "alto": alto,
        "cantidad": cantidad,
        "m2": m2,
      };
}
