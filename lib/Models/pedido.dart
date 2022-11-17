
import 'package:termopanelescco/Models/detalle_pedido.dart';

class Pedido {
  String? id;
  final String? identificador;
  final DateTime fecha;
  final List<DetallePedido>? detallePedido;
  final String? usuario;
  final double? total;

  Pedido({
    this.id = "",
    required this.identificador,
    required this.fecha,
    required this.detallePedido,
    required this.total,
    required this.usuario,
  });
   
  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
      id: json["id"],
      detallePedido: [DetallePedido.fromJson(json['detallePedido'])],
      fecha: json['fecha'],
      identificador: json['identificador'],
      total: json['total'],
      usuario: json["usuario"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "fecha": fecha,
        "identificador": identificador,
        "total": total,
        "detallePedido": detallePedido!.map((e) => e.toJson()),
      };
}
