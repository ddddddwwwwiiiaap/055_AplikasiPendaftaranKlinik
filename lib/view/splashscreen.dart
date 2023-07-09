import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
                buildHeader(size),
                buildLogoApp(),
                buildDescApp(),
                buildButtonNext(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(Size size) {
    return SizedBox(
      width: size.width,
      height: size.height / 4,
      child: Stack(
        children: [
          Positioned(
            top: -60,
            left: 240,
            right: 0,
            bottom: 0,
            child: Image.asset('assets/image/clock.png'),
          ),
          Positioned.fill(
            top: 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      textWelcome,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Kami Siap Melayani\nAnda",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLogoApp() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Image.asset(
        'assets/image/logo.png',
        height: 300,
      ),
    );
  }

  Widget buildDescApp() {
    return Container(
      margin: const EdgeInsets.only(bottom: 90),
      child: const Center(
        child: Text(
          descApp,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildButtonNext() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const Login(),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(colorButton),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      child: const SizedBox(
        width: 120,
        height: 40,
        child: Center(
          child: Text(
            textNext,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
