/// Nama Module : antrian.dart
/// Deskripsi : Modul ini digunakan untuk menampilkan antrian pasien
/// 
/// Kode ini berisi implementasi tampilan dan logika untuk halaman antrian pasien

import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/homepage_pasien.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// AntrianPages class adalah widget yang digunakan untuk membuat tampilan halaman antrian pasien
class AntrianPages extends StatefulWidget {
  /// noAntrian adalah variabel bertipe int yang digunakan untuk menyimpan nomor antrian pasien
  int? noAntrian;
  /// poli adalah variabel bertipe String yang digunakan untuk menyimpan poli pasien
  String? poli;
  /// Fungsi AntrianPages({Key? key}) adalah konstruktor dari class AntrianPages yang menerima parameter key dengan tipe Key yang bersifat opsional dan noAntrian dengan tipe int dan poli dengan tipe String yang bersifat opsional
  /// Fungsi ini akan dijalankan ketika class AntrianPages dipanggil dengan parameter noAntrian dan poli.
  AntrianPages({Key? key, this.noAntrian, this.poli}) : super(key: key);

  @override
  State<AntrianPages> createState() => _AntrianPagesState();
}

/// _AntrianPagesState class adalah class yang digunakan untuk menampilkan halaman antrian pasien
class _AntrianPagesState extends State<AntrianPages> {
  final Stream<QuerySnapshot> _streamAntrianPasien =
      FirebaseFirestore.instance.collection("antrian pasien").snapshots();

  int? noAntrianSedangDilayani = 25;

  /// initState digunakan untuk mengambil data noAntrianSedangDilayani dari database
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("antrian pasien")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        noAntrianSedangDilayani = doc['noAntrian'];
      });
    });
  }

  /// Method build digunakan untuk membuat tampilan halaman antrian pasien
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorButtonHome,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePagePasien(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(titleAntrian),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            buildItemAntrian(size),
            buildEllipse(),
            buildTextInformasi(size),
            buildImage(),
            buildEllipseBottom1(),
            buildEllipseBottom2()
          ],
        ),
      ),
    );
  }

  /// Method buildItemAntrian digunakan untuk membuat tampilan item antrian pasien
  Widget buildItemAntrian(Size size) {
    return Column(
      children: [
        
          Container(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 10),
            width: size.width,
            height: size.height / 5,
            decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  textSedangDilayani,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  "${widget.noAntrian}",
                  style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          ),
        
        Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 0, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorButtonHome),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    textNoAntrian,
                    style: TextStyle(color: colorPinkText, fontSize: 12),
                  ),
                  Text(
                    "${widget.noAntrian}",
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorPinkText),
                  )
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _streamAntrianPasien,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error!"),
                    );
                  } else {
                    int sisaAntrian = int.parse("${noAntrianSedangDilayani}") -
                        int.parse("${widget.noAntrian}");
                    return Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            textSisaAntrian,
                            style:
                                TextStyle(color: colorPinkText, fontSize: 12),
                          ),
                          Text(
                            "${int.parse(sisaAntrian.toString())}",
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colorPinkText),
                          )
                        ],
                      ),
                    );
                  }
                }),
            StreamBuilder<QuerySnapshot>(
                stream: _streamAntrianPasien,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error!"),
                    );
                  } else {
                    int totalAntrianPasien = snapshot.data!.docs.length;
                    return Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            textJumlahPendaftar,
                            style:
                                TextStyle(color: colorPinkText, fontSize: 12),
                          ),
                          Text(
                            "${int.parse(totalAntrianPasien.toString())}",
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colorPinkText),
                          )
                        ],
                      ),
                    );
                  }
                }),
          ],
        )
      ],
    );
  }

  /// Method buildEllipse digunakan untuk membuat tampilan elips pada halaman antrian pasien
  Widget buildEllipse() {
    return Positioned(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 140),
                child: Image.asset("assets/ellipse/ellipse5.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Method buildTextInformasi digunakan untuk membuat tampilan text informasi pada halaman antrian pasien
  Widget buildTextInformasi(Size size) {
    return Positioned(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: size.width / 2,
          padding: const EdgeInsets.all(16),
          child: const Stack(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 140),
                  child: Text(
                    textInformasiAntrian,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// Method buildImage digunakan untuk membuat tampilan gambar pada halaman antrian pasien
  Widget buildImage() {
    return Positioned(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 240, left: 40),
                child: Image.asset("assets/image/suster3.png"),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Method buildEllipseBottom1 digunakan untuk membuat tampilan elips pada bagian bawah halaman antrian pasien
  Widget buildEllipseBottom1() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          child: Stack(
            children: [
              Image.asset("assets/ellipse/ellipse6.png"),
            ],
          ),
        ),
      ),
    );
  }

  /// Method buildEllipseBottom2 digunakan untuk membuat tampilan elips pada bagian bawah halaman antrian pasien
  Widget buildEllipseBottom2() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          child: Stack(
            children: [
              Image.asset("assets/ellipse/ellipse7.png"),
            ],
          ),
        ),
      ),
    );
  }
}
