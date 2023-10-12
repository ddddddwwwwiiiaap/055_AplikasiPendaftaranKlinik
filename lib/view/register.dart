/// Nama Module: register.dart
/// Deskripsi: Modul untuk layar register dalam aplikasi Flutter pendaftaran klinik.
/// 
/// Kode ini berisi implementasi tampilan dan logika untuk halaman register.
/// Pengguna dapat memasukkan nama, email, dan password mereka untuk mendaftar ke aplikasi

import 'package:aplikasipendaftaranklinik/controller/auth_controller.dart';
import 'package:aplikasipendaftaranklinik/model/user_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/login.dart';
import 'package:flutter/material.dart';

/// Register class adalah widget yang digunakan untuk membuat tampilan halaman register
class Register extends StatefulWidget {
  /// Fungsi Register({Key? key}) adalah konstruktor dari class Register yang menerima parameter key dengan tipe Key yang bersifat opsional
  /// Fungsi ini akan dijalankan ketika class Register dipanggil
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

/// _RegisterState class digunakan untuk membuat state dari widget Register
class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final authCtr = AuthController(isEdit: false);
  String? nama;
  String? email;
  String? password;
  String? role = 'pasien';

  bool _showPassword = true;

  /// Toggle keamanan tampak password untuk menampilkan atau menyembunyikan password
  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  /// Digunakan untuk menampilkan dialog loading
  showAlertDialogLoading(BuildContext context) {
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
          )
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

  /// Digunakan untuk menampilkan dialog konfirmasi registrasi berhasil
  signUpDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: colorPinkText,
                size: 72,
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  'Registrasi Berhasil',
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: colorPinkText,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Method build digunakan untuk membuat tampilan halaman register
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorPrimary[50]!,
              colorPrimary[100]!,
              colorPrimary[200]!,
              colorPrimary[300]!,
              colorPrimary[400]!,
              colorPrimary[500]!,
              colorPrimary[600]!,
              colorPrimary[700]!,
              colorPrimary[800]!,
              colorPrimary[900]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(),
                buildIcon(),
                buildFormRegister(),
                buildButtonRegister(),
                buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Method buildHeader digunakan untuk membuat tampilan header pada halaman register
  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  titleRegister,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset(
                "assets/image/line.png",
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Method buildIcon digunakan untuk membuat tampilan icon pada halaman register
  Widget buildIcon() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Image.asset("assets/image/double_doctor.png"),
    );
  }

  /// Method buildFormRegister digunakan untuk membuat tampilan form register pada halaman register
  Widget buildFormRegister() {
    return Form(
      key: formkey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16),
                  prefixIcon: Icon(
                    Icons.account_circle_rounded,
                  ),
                  border: InputBorder.none,
                  hintText: 'Nama',
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  nama = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16),
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                  border: InputBorder.none,
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  } else if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextFormField(
                obscureText: _showPassword,
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16),
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      togglePasswordVisibility();
                    },
                    child: _showPassword
                        ? Icon(
                            Icons.visibility_off,
                            color: colorPrimary,
                          )
                        : Icon(
                            Icons.visibility,
                            color: colorPrimary,
                          ),
                  ),
                  border: InputBorder.none,
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Method buildButtonRegister digunakan untuk membuat tampilan button register pada halaman register
  Widget buildButtonRegister() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: ElevatedButton(
        onPressed: () async {
          if (formkey.currentState!.validate()) {
            showAlertDialogLoading(context);
            UserModel? registeredUser =
                await authCtr.registerWithEmailAndPassword(
              email!,
              password!,
              nama!,
              role = 'pasien',
            );
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            if (registeredUser != null) {
              signUpDialog();
            } else {
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Register Gagal'),
                  content: const Text('Email sudah terdaftar'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          }
        },
        child: Container(
          width: 120,
          height: 40,
          child: Center(
            child: Text(
              "Register",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorButton),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }

  /// Method buildFooter digunakan untuk membuat tampilan footer pada halaman register
  Widget buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              textLogin,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Login(),
                ),
              );
            },
            child: const Text(
              titleLogin,
              style: TextStyle(color: colorButton),
            ),
          ),
        ],
      ),
    );
  }
}
