import 'package:aplikasipendaftaranklinik/controller/auth_controller.dart';
import 'package:aplikasipendaftaranklinik/model/user_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final authCtr = AuthController(isEdit: false);
  String? email;
  String? password;

  late bool _showPassword = true;

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
                buildFormLogin(),
                buildButtonLogin(),
                buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  titleLogin,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset("assets/image/line.png"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIcon() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Image.asset("assets/image/double_doctor.png"),
    );
  }

  Widget buildFormLogin() {
    return Form(
      key: formkey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16),
                  prefixIcon: Icon(Icons.email),
                  border: InputBorder.none,
                  hintText: textEmail,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
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
              margin: const EdgeInsets.only(bottom: 40),
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
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTap: togglePasswordVisibility,
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
                  if (value!.isEmpty) {
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

  Widget buildButtonLogin() {
    return ElevatedButton(
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          UserModel? loginUser = await authCtr.signInWithEmailAndPassword(
            email!,
            password!,
            context,
          );
          if (loginUser != null) {}
        }
      },
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(colorButton),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))),
      child: Container(
        width: 120,
        height: 40,
        child: const Center(
          child: Text(
            titleLogin,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      //margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              textDaftarRegister,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Register())),
            child: const Text(
              titleRegister,
              style: TextStyle(color: colorButton),
            ),
          ),
        ],
      ),
    );
  }
}
