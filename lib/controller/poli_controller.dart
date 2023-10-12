/// Nama Module: poli_controller.dart
/// Deskripsi: Modul ini digunakan untuk membuat controller poli
///
/// Kode ini berisi implementasi controller poli

import 'dart:async';

import 'package:aplikasipendaftaranklinik/model/poli_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// poliController class adalah class yang digunakan untuk membuat controller poli
class PoliController {
  /// poliCollection adalah variabel yang digunakan untuk menghubungkan ke collection 'poli' di firebase
  final poliCollection = FirebaseFirestore.instance.collection('poli');

  /// streamController adalah variabel yang digunakan untuk mengatur stream dari data poli
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  /// stream adalah variabel yang digunakan untuk mengatur stream dari data poli
  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  /// Future addPoli digunakan untuk menambahkan data poli ke firebase
  Future<void> addPoli(PoliModel pmmodel) async {
    final poli = pmmodel.toMap();

    final DocumentReference docref = await poliCollection.add(poli);

    final String docId = docref.id;

    final PoliModel poliModel =
        PoliModel(uId: docId, namaPoli: pmmodel.namaPoli);
    await docref.update(poliModel.toMap());
  }

  /// Future getPoli digunakan untuk mengambil data poli dari firebase
  Future getPoli() async {
    final poli = await poliCollection.get();
    streamController.add(poli.docs);
    return poli.docs;
  }

  /// Future deletePoli digunakan untuk menghapus data poli dari firebase
  Future<void> updatePoli(PoliModel pmmodel) async {
    final poli = pmmodel.toMap();

    await poliCollection.doc(pmmodel.uId).update(poli);
  }
}
