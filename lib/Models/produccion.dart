import 'package:termopanelescco/Models/plancha.dart';

class Produccion {
  String? id;
  final String? identificador;
  final DateTime fecha;
  final List<Plancha>? plancha;
  final String? usuario;
  final int largoPlancha;
  final int altoPLancha;

  Produccion({
    this.id = "",
    required this.identificador,
    required this.fecha,
    required this.plancha,
    required this.largoPlancha,
    required this.altoPLancha,
    required this.usuario,
  });

  factory Produccion.fromJson(Map<String, dynamic> json) => Produccion(
      id: json["id"],
      plancha: [
        Plancha.fromJson(json['plancha'])
      ],
      fecha: json['fecha'],
      identificador: json['identificador'],
      usuario: json["usuario"],
      altoPLancha: json["altoPLancha"],
      largoPlancha: json["largoPlancha"],);

  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "fecha": fecha,
        "identificador": identificador,
         "altoPlancha": altoPLancha,
        "largoPlancha": largoPlancha,
        "plancha": plancha!.map((e) => e.toJson()),
      };
}
