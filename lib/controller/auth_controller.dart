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

class AuthController {
  final bool isEdit;
  AuthController(
      {Key? key,
      required this.isEdit})
      : super();


  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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

  void showAlertUserNotFound(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text(titleError),
      content: const Text("Maaf, User Tidak Ditemukan!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
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

  void showAlertUserWrongPassword(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text(titleError),
      content: const Text("Maaf, Password Salah!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
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

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    showAlertDialogLoading(context);
    try {
      final UserCredential userCredential = //untuk
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user; //untuk

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