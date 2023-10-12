/// Nama Module: main.dart
/// Deskripsi: Modul utama aplikasi Flutter yang akan berfungsi sebagai entry point
/// 
/// - Import berbagai library yang diperlukan untuk aplikasi
/// - Menginisialisasi Firebase untuk digunakan pada aplikasi
/// - Membuat dan menjalankan instance aplikasi Flutter (MyApp)

import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Fungsi main adalah titik masuk utama aplikasi
/// Fungsi ini akan dijalankan pertama kali ketika aplikasi dijalankan
Future main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// MyApp class adalah root dari aplikasi Flutter
class MyApp extends StatelessWidget {
  /// Fungsi MyApp({Key? key}) adalah konstruktor dari class MyApp yang menerima parameter key dengan tipe Key yang bersifat opsional
  /// Fungsi ini akan dijalankan ketika class MyApp dipanggil
  const MyApp({super.key});

  /// Method build digunakan untuk membuat tampilan aplikasi
  /// Ini adalah method yang pertama kali dipanggil ketika aplikasi dimulai
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: titleApp,
      theme: ThemeData(
        primarySwatch: colorPrimary,
      ),
      home: const SplashScreen(),
    );
  }
}
