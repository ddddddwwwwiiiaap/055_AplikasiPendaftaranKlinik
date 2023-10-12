/// Nama Module: auth_controller.dart
/// Deskripsi: Modul ini digunakan untuk membuat controller auth
/// 
/// Kode ini berisi implementasi controller auth

import 'package:aplikasipendaftaranklinik/model/user_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/admin/homepage_admin.dart';
import 'package:aplikasipendaftaranklinik/view/login.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/homepage_pasien.dart';
import 'package:aplikasipendaftaranklinik/view/role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// AuthController class adalah class yang digunakan untuk membuat controller auth
class AuthController {
  /// bool isEdit adalah variabel yang digunakan untuk menentukan apakah user sedang mengedit data atau tidak
  final bool isEdit;
  /// Fungsi AuthController({Key? key, required this.isEdit}) adalah konstruktor dari class AuthController yang menerima parameter key dengan tipe Key yang bersifat opsional dan isEdit dengan tipe bool yang bersifat wajib
  /// Fungsi ini akan dijalankan ketika class AuthController dipanggil
  AuthController({Key? key, required this.isEdit}) : super();

  /// FirebaseAuth auth adalah instance dari FirebaseAuth
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// CollectionReference userCollection adalah instance dari CollectionReference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  /// Future registerWithEmailAndPassword digunakan untuk mendaftarkan user baru
  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password, String nama, String role) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        final UserModel currentUser = UserModel(
          uId: user.uid,
          nama: nama,
          email: user.email ?? '',
          role: role,
          alamat: '',
          nomorhp: '',
          tglLahir: '',
          noAntrian: 0,
          poli: '',
        );

        await userCollection.doc(user.uid).set(currentUser.toMap());

        return currentUser;
      }
    } catch (e) {
      print('Error signin in: $e');
    }
    return null;
  }

  /// showAlertUserNotFound digunakan untuk menampilkan alert dialog ketika user tidak ditemukan
  void showAlertUserNotFound(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text(titleError),
      content: const Text("Maaf, User Tidak Ditemukan!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          ),
          child: const Text(
            "OK",
            style: TextStyle(color: colorPinkText),
          ),
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// showAlertUserWrongPassword digunakan untuk menampilkan alert dialog ketika password salah
  void showAlertUserWrongPassword(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text(titleError),
      content: const Text("Maaf, Password Salah!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          ),
          child: const Text(
            "OK",
            style: TextStyle(color: colorPinkText),
          ),
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// showAlertDialogLoading digunakan untuk menampilkan alert dialog ketika loading
  void showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: const Text(
              "Loading...",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ///Future signInWithEmailAndPassword digunakan untuk login dengan email dan password
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    showAlertDialogLoading(context);
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot snapshot =
            await userCollection.doc(user.uid).get();
        final UserModel currentUser = UserModel(
          uId: user.uid,
          nama: snapshot['nama'],
          email: user.email ?? '',
          role: snapshot['role'],
          alamat: snapshot['alamat'],
          nomorhp: snapshot['nomorhp'],
          tglLahir: snapshot['tglLahir'],
          noAntrian: snapshot['noAntrian'],
          poli: snapshot['poli'],
        );
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Role()),
          (route) => false,
        );
        return currentUser;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showAlertUserNotFound(context);
      } else if (e.code == 'wrong-password') {
        showAlertUserWrongPassword(context);
      }
    }
    return null;
  }

  /// Future<UserModel?> getUser digunakan untuk mendapatkan data user
  Future<UserModel?> getUser() async {
    final User? user = auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
        (result) {
          if (result.docs.isNotEmpty) {
            final UserModel currentUser = UserModel(
              uId: user.uid,
              nama: result.docs[0].data()['nama'],
              email: user.email ?? '',
              role: result.docs[0].data()['role'],
              nomorhp: result.docs[0].data()['nomorhp'],
              tglLahir: result.docs[0].data()['tglLahir'],
              alamat: result.docs[0].data()['alamat'],
              noAntrian: result.docs[0].data()['noAntrian'],
              poli: result.docs[0].data()['poli'],
            );
            return currentUser;
          }
        },
      );
    }
    return null;
  }

  /// Future<void> signOut digunakan untuk logout
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
        (route) => false);
  }

  /// Future<UserModel?> updateProfile digunakan untuk mengupdate data user
  Future<UserModel?> updateProfileAdmin(
      String nama,
      String email,
      String nomorHp,
      String tglLahir,
      String alamat,
      BuildContext context) async {
    if (isEdit) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          await transaction.update(documentReference, {
            'nama': nama,
            'email': email,
            'nomorhp': nomorHp,
            'tglLahir': tglLahir,
            'alamat': alamat,
          });
        }
      });

      infoUpdate(context);
    }
    return null;
  }

  /// infoUpdate digunakan untuk menampilkan alert dialog ketika data berhasil diupdate
  void infoUpdate(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(titleSuccess),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Data Pribadi Anda Berhasil di Perbarui",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePageAdmin()),
              ),
              child: const Text(
                "OK",
                style: TextStyle(color: colorPinkText),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Future<UserModel?> updateProfilePasien digunakan untuk mengupdate data user
  Future<UserModel?> updateProfilePasien(
      String nama,
      String email,
      String nomorHp,
      String tglLahir,
      String alamat,
      BuildContext context) async {
    if (isEdit) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          await transaction.update(documentReference, {
            'nama': nama,
            'email': email,
            'nomorhp': nomorHp,
            'tglLahir': tglLahir,
            'alamat': alamat,
          });
        }
      });

      infoUpdatePasien(context);
    }
    return null;
  }

  /// infoUpdatePasien digunakan untuk menampilkan alert dialog ketika data berhasil diupdate
  void infoUpdatePasien(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(titleSuccess),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Data Pribadi Anda Berhasil di Perbarui",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePagePasien()),
              ),
              child: const Text(
                "OK",
                style: TextStyle(color: colorPinkText),
              ),
            ),
          ],
        );
      },
    );
  }
}
