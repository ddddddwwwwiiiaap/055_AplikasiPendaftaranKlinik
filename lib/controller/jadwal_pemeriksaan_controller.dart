/// Nama Module: jadwal_pemeriksaan_controller.dart
/// Deskripsi: Modul ini digunakan untuk membuat controller jadwal pemeriksaan
///
/// Kode ini berisi implementasi controller jadwal pemeriksaan

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// JadwalPemeriksaanController class adalah class yang digunakan untuk membuat controller jadwal pemeriksaan
class JadwalPemeriksaanController {
  /// streamController adalah variabel yang digunakan untuk mengatur stream dari data jadwal pemeriksaan yang akan ditampilkan pada halaman jadwal pemeriksaan pasien dan jadwal pemeriksaan admin
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  /// stream adalah variabel yang digunakan untuk mengatur stream dari data jadwal pemeriksaan
  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  /// Future deleteAntrianPoliAutomatically digunakan untuk menghapus antrian poli secara otomatis
  final Stream<QuerySnapshot> streamAntrianUsers = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("antrian")
      .snapshots();

  /// Future deleteAntrianPoliAutomatically digunakan untuk menghapus antrian poli secara otomatis
  Future<dynamic> deleteAntrianPoli(String documentId) async {
    try {
      User? users = FirebaseAuth.instance.currentUser;
      QuerySnapshot docUsersAntrian = await FirebaseFirestore.instance
          .collection('users')
          .doc(users!.uid)
          .collection('antrian')
          .get();
      List<DocumentSnapshot> docUserAntrianCount = docUsersAntrian.docs;

      if (docUserAntrianCount.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(users.uid)
            .collection('antrian')
            .doc(docUserAntrianCount[docUserAntrianCount.length - 1].id)
            .delete();

        QuerySnapshot docAntrianPasien =
            await FirebaseFirestore.instance.collection('antrian pasien').get();
        List<DocumentSnapshot> docAntrianPasienCount = docAntrianPasien.docs;

        if (docAntrianPasienCount.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('antrian pasien')
              .doc(docAntrianPasienCount[docAntrianPasienCount.length - 1].id)
              .delete();

          await decrementNoAntrian(users.uid);
        }
      }
    } catch (e) {
      return e;
    }
  }

  /// Future getJadwalPemeriksaan digunakan untuk mendapatkan data jadwal pemeriksaan
  Future<void> decrementNoAntrian(String userId) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    /// FirebasesFirestore.instance.runTransaction digunakan untuk mengurangi nomor antrian
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userRef);
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        int? noAntrian = userData['noAntrian'] as int?;
        if (noAntrian != null && noAntrian > 0) {
          noAntrian--;

          transaction.update(userRef, {'noAntrian': noAntrian});
        }
      }
    });
  }
}
