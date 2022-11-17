import 'package:termopanelescco/Models/fila.dart';

class Columna {

final List<Fila> fila;

Columna({ required this.fila});

factory Columna.fromJson(Map<dynamic, dynamic> json) =>
      Columna(fila: [Fila.fromJson(json['fila'])]
       
      );

  Map<String, dynamic> toJson() => {
         "fila": fila.map((e) => e.toJson()),
      };



}