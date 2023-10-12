/// Nama Module: role.dart
/// Deskripsi: Modul untuk menentukan role pengguna
/// 
/// Setelah role pengguna ditentukan, pengguna akan diarahkan ke halaman sesuai dengan role mereka.

import 'package:aplikasipendaftaranklinik/controller/auth_controller.dart';
import 'package:aplikasipendaftaranklinik/view/admin/homepage_admin.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/homepage_pasien.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Role class adalah widget yang digunakan untuk membuat tampilan halaman role
class Role extends StatefulWidget {
  /// Fungsi Role({Key? key}) adalah konstruktor dari class Role yang menerima parameter key dengan tipe Key yang bersifat opsional
  /// Fungsi ini akan dijalankan ketika class Role dipanggil
  const Role({super.key});

  @override
  State<Role> createState() => _RoleState();
}

/// _RoleState class digunakan untuk membuat state dari widget Role
class _RoleState extends State<Role> {
  final authCtr = AuthController(isEdit: false);

  /// initState digunakan untuk menjalankan kode sebelum tampilan widget dibuat
  @override
  void initState() {
    super.initState();
    authCtr.getUser();
  }

  /// Method build digunakan untuk membuat tampilan halaman role
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic>? data = snapshot.data!.data();
          String? role = data!['role'];

          if (role.toString() == "pasien") {
            return const HomePagePasien();
          } else if (role.toString() == "admin") {
            return const HomePageAdmin();
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
