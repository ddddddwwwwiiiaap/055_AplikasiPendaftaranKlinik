/// Nama Module: riwayat_pemeriksaan_controller.dart
/// Deskripsi: Modul ini digunakan untuk membuat controller riwayat pemeriksaan
/// 
/// Kode ini berisi implementasi controller riwayat pemeriksaan

import 'package:cloud_firestore/cloud_firestore.dart';

/// RiwayatPemeriksaanController class adalah class yang digunakan untuk membuat controller riwayat pemeriksaan
class RiwayatPemeriksaanController{

  /// Method getRiwayatPasienMasuk digunakan untuk mengambil data riwayat pasien masuk dari firebase
    final Stream<QuerySnapshot> streamRiwayatPasienMasuk =
      FirebaseFirestore.instance.collection("riwayat pasien masuk").snapshots();
}