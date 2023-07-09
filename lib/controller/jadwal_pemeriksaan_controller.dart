import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JadwalPemeriksaanController {
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  final Stream<QuerySnapshot> streamAntrianUsers = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("antrian")
      .snapshots();

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

  Future<void> decrementNoAntrian(String userId) async {
  DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot userSnapshot = await transaction.get(userRef);
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

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
