import 'package:aplikasipendaftaranklinik/model/user_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
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
          jekel: '',
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
          jekel: snapshot['jekel'],
          nomorhp: snapshot['nomorhp'],
          tglLahir: snapshot['tglLahir'],
          noAntrian: snapshot['noAntrian'],
          poli: snapshot['poli'],
        );
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Register()),
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
              jekel: result.docs[0].data()['jekel'],
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
}
