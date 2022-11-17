import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'columna.dart';

class Plancha with ChangeNotifier {
final List<Columna> columna ;

  Plancha({
   required  this.columna,  
  });

  factory Plancha.fromJson(Map<dynamic, dynamic> json) =>
      Plancha(columna: [Columna.fromJson(json['columna'])]
        
      );

  Map<String, dynamic> toJson() => {
        "columna": columna.map((e) => e.toJson()),

      };
}
