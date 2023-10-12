/// Nama Module: pendaftaran_controller.dart
/// Deskripsi: Modul ini digunakan untuk membuat controller pendaftaran
///
/// Kode ini berisi implementasi controller pendaftaran

import 'dart:async';

import 'package:aplikasipendaftaranklinik/controller/poli_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// PendaftaranController class adalah class yang digunakan untuk membuat controller pendaftaran
class PendaftaranController {
  /// uId adalah variabel yang digunakan untuk menyimpan id user
  String? uId;

  /// nama adalah variabel yang digunakan untuk menyimpan nama pasien
  String? nama;

  /// poliController adalah variabel yang digunakan untuk mengatur controller poli
  var poliController = PoliController();

  /// noAntrian adalah variabel yang digunakan untuk menyimpan nomor antrian
  String? noAntrian;

  /// status adalah variabel yang digunakan untuk menyimpan status
  String? status;

  /// namaPoli adalah variabel yang digunakan untuk menyimpan nama poli
  String? namaPoli;

  /// tanggalantrian adalah variabel yang digunakan untuk menyimpan tanggal antrian
  final TextEditingController tanggalantrian = TextEditingController();

  /// waktuantrian adalah variabel yang digunakan untuk menyimpan waktu antrian
  final TextEditingController waktuantrian = TextEditingController();

  /// pendaftaranCollection adalah variabel yang digunakan untuk menghubungkan ke collection 'antrian pasien' di firebase
  final pendaftaranCollection =
      FirebaseFirestore.instance.collection('antrian pasien');

  /// streamController adalah variabel yang digunakan untuk mengatur stream dari data pendaftaran
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  /// stream adalah variabel yang digunakan untuk mengatur stream dari data pendaftaran
  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  /// selectedDate adalah variabel yang digunakan untuk menyimpan tanggal yang dipilih
  DateTime selectedDate = DateTime.now();

  /// selectedTime adalah variabel yang digunakan untuk menyimpan waktu yang dipilih
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  /// ini adalah variabel yang digunakan untuk mengatur format tanggal
  String? hour, minute, time;

  /// Future addPendaftaran digunakan untuk menambahkan data pendaftaran ke firebase
  Future<List> getPolis() async {
    var polis = await poliController.getPoli();
    return polis;
  }
}
