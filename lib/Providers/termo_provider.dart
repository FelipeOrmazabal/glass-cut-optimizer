

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../Models/termo.dart';

class TermoP with ChangeNotifier {
  
      final separadorController= TextEditingController();
       final vidrio1Controller = TextEditingController();
        final vidrio2Controller = TextEditingController();
         final valorController = TextEditingController();

  Future addTermo(Termo termo) async {
    final docTermo = FirebaseFirestore.instance
        .collection("termopaneles")
        .withConverter(
          fromFirestore: Termo.fromFirestore,
          toFirestore: (Termo termo, options) => termo.toFirestore(),
        )
        .doc();
    termo.id = docTermo.id;
    await docTermo.set(termo);
    notifyListeners();
  }

  Stream<List<Termo>> read() {
    return FirebaseFirestore.instance
        .collection("termopaneles")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Termo.fromfirestore(doc.data()))
          .toList();
    });
  }

  Future delete(String id) async {
    final docTermo = FirebaseFirestore.instance
        .collection("termopaneles")
       
        .doc(id);

    docTermo.delete();

    notifyListeners();
  }

  Future edit(Termo termo) async {
    final docTermo = FirebaseFirestore.instance
        .collection("termopaneles")
        
        .doc(termo.id);

    docTermo.update({'valor':termo.valor});
    notifyListeners();
  }



}



