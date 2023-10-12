/// Nama Module : Riwayat Pemeriksaan
/// Deskripsi : Modul ini digunakan untuk menampilkan riwayat pemeriksaan pasien
/// 
/// Kode ini berisi implementasi tampilan dan logika untuk halaman riwayat pemeriksaan pasien

import 'package:aplikasipendaftaranklinik/controller/riwayat_pemeriksaan_controller.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/homepage_pasien.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// RiwayatPemeriksaanPages class adalah widget yang digunakan untuk membuat tampilan halaman riwayat pemeriksaan pasien
class RiwayatPemeriksaanPages extends StatefulWidget {
  /// String? uid digunakan untuk menyimpan uid dari pasien
  String? uid;
  ///RiwayatPemeriksaanPages({Key? key, String? uid}) digunakan untuk membuat konstruktor dari class RiwayatPemeriksaanPages yang menerima parameter key dengan tipe Key yang bersifat opsional dan uid dengan tipe String yang bersifat opsional
  RiwayatPemeriksaanPages({Key? key, this.uid}) : super(key: key);

  @override
  State<RiwayatPemeriksaanPages> createState() =>
      _RiwayatPemeriksaanPagesState();
}

/// _RiwayatPemeriksaanPagesState class adalah class yang digunakan untuk menampilkan halaman riwayat pemeriksaan pasien
class _RiwayatPemeriksaanPagesState extends State<RiwayatPemeriksaanPages> {
  var riwayatPemeriksaanController = RiwayatPemeriksaanController();

  /// Method build digunakan untuk membuat tampilan halaman riwayat pemeriksaan pasien
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorHome,
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
        title: Text(titleRiwayatPemeriksaan),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            buildBackground(size),
            buildImageBottom(),
          ],
        ),
      ),
    );
  }

  /// Method buildBackground digunakan untuk membuat tampilan background halaman riwayat pemeriksaan pasien
  Widget buildBackground(Size size) {
    return Container(
      margin: const EdgeInsets.all(24),
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: StreamBuilder(
        stream: riwayatPemeriksaanController.streamRiwayatPasienMasuk,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum Ada Data!"),
            );
          } else {
            bool hasDataForUid = false;
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot data) {
                if (widget.uid.toString() == data['uid pasien']) {
                  hasDataForUid = true;
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        "poli ${data['poli']}".toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("No. Antrian"),
                                Text(
                                  "${data['noAntrian']}",
                                  style: TextStyle(
                                    color: colorPinkText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tanggal"),
                                Text(
                                  "${data['tanggal antrian']}",
                                  style: TextStyle(
                                    color: colorPinkText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Jam"),
                                Text(
                                  "${data['waktu antrian']}",
                                  style: TextStyle(
                                    color: colorPinkText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              "${data['status']}",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            );
          }
        },
      ),
    );
  }

  /// Method buildImageBottom digunakan untuk membuat tampilan gambar pada bagian bawah halaman riwayat pemeriksaan pasien
  Widget buildImageBottom() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          child: Image.asset("assets/image/suster.png"),
        ),
      ),
    );
  }
}
