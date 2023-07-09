import 'dart:async';

import 'package:aplikasipendaftaranklinik/controller/poli_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendaftaranController {
  String? uId;
  String? nama;
  var poliController = PoliController();
  String? noAntrian;
  String? status;
  String? namaPoli;

  final TextEditingController tanggalantrian = TextEditingController();
  final TextEditingController waktuantrian = TextEditingController();

  final pendaftaranCollection =
      FirebaseFirestore.instance.collection('antrian pasien');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  String? hour, minute, time;

  Future<List> getPolis() async {
    var polis = await poliController.getPoli();
    return polis;
  }
}
