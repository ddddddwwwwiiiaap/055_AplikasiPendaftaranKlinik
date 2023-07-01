import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatPemeriksaanController{
  
    final Stream<QuerySnapshot> streamRiwayatPasienMasuk =
      FirebaseFirestore.instance.collection("riwayat pasien masuk").snapshots();
}