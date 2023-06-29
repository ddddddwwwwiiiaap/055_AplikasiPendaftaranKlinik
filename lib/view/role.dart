import 'package:aplikasipendaftaranklinik/controller/auth_controller.dart';
import 'package:aplikasipendaftaranklinik/view/register.dart';
import 'package:aplikasipendaftaranklinik/view/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Role extends StatefulWidget {
  const Role({super.key});

  @override
  State<Role> createState() => _RoleState();
}

class _RoleState extends State<Role> {
  final authCtr = AuthController();

  @override
  void initState() {
    super.initState();
    authCtr.getUser();
  }

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
            return const SplashScreen();
          } else if (role.toString() == "admin") {
            return const Register();
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