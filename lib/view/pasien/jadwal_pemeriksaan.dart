/// Nama Module : jadwal_pemeriksaan.dart
/// Deskripsi : Modul ini digunakan untuk menampilkan jadwal pemeriksaan pasien
/// 
/// Kode ini berisi implementasi tampilan dan logika untuk halaman jadwal pemeriksaan pasien

import 'package:aplikasipendaftaranklinik/controller/jadwal_pemeriksaan_controller.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/homepage_pasien.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// JadwalPemeriksaanPages class adalah widget yang digunakan untuk membuat tampilan halaman jadwal pemeriksaan pasien
class JadwalPemeriksaanPages extends StatefulWidget {
  /// String? uid digunakan untuk menyimpan uid dari pasien
  String? uid;
  /// Fungsi JadwalPemeriksaanPages({Key? key, this.uid}) adalah konstruktor dari class JadwalPemeriksaanPages yang menerima parameter key dengan tipe Key yang bersifat opsional dan uid dengan tipe String
  /// Fungsi ini akan dijalankan ketika class JadwalPemeriksaanPages dipanggil
  JadwalPemeriksaanPages({
    Key? key,
    this.uid,
  }) : super(key: key);

  @override
  State<JadwalPemeriksaanPages> createState() => _JadwalPemeriksaanPagesState();
}

/// _JadwalPemeriksaanPagesState class adalah class yang digunakan untuk menampilkan halaman jadwal pemeriksaan pasien
class _JadwalPemeriksaanPagesState extends State<JadwalPemeriksaanPages> {
  var jadwalPemeriksaanController = JadwalPemeriksaanController();

  /// initState digunakan untuk menjalankan method deleteAntrianPoliAutomatically
  @override
  void initState() {
    super.initState();
    deleteAntrianPoliAutomatically();
  }

  /// Future deleteAntrianPoliAutomatically digunakan untuk menghapus antrian poli secara otomatis
  Future<void> deleteAntrianPoliAutomatically() async {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    if (currentHour >= 23 && currentHour <= 24  || currentHour >= 00 && currentHour < 6) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('antrian pasien').get();

      List<DocumentSnapshot> documents = querySnapshot.docs;
      List<Future<void>> deleteOperations = [];

      for (var document in documents) {
        deleteOperations.add(document.reference.delete());
      }

      await Future.wait(deleteOperations);

      // Hapus juga data dari koleksi 'antrian' di bawah ini

      User? users = FirebaseAuth.instance.currentUser;
      QuerySnapshot antrianSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(users!.uid)
          .collection('antrian')
          .get();

      List<DocumentSnapshot> antrianDocuments = antrianSnapshot.docs;
      List<Future<void>> antrianDeleteOperations = [];

      for (var document in antrianDocuments) {
        antrianDeleteOperations.add(document.reference.delete());
      }

      await Future.wait(antrianDeleteOperations);
    }
  }

  /// Method build digunakan untuk membuat tampilan halaman jadwal pemeriksaan pasien
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
        title: Text(titleJadwalPemeriksaan),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [buildBackground(size), buildImageBottom()],
        ),
      ),
    );
  }

  /// Method buildBackground digunakan untuk membuat tampilan background halaman jadwal pemeriksaan pasien
  Widget buildBackground(Size size) {
    return Container(
      margin: const EdgeInsets.all(24),
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.white),
      child: StreamBuilder(
        stream: jadwalPemeriksaanController.streamAntrianUsers,
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
            return ListView(
              children: snapshot.data!.docs.map(
                (DocumentSnapshot data) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("poli ${data['poli']}".toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("No. Antrian"),
                                Text(
                                  "${data['noAntrian']}",
                                  style: TextStyle(
                                      color: colorPinkText,
                                      fontWeight: FontWeight.bold),
                                )
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
                                      fontWeight: FontWeight.bold),
                                )
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
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Divider()
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Hapus Data"),
                                content: Text(
                                    "Apakah Anda yakin ingin menghapus data ini?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Batal"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Hapus"),
                                    onPressed: () {
                                      jadwalPemeriksaanController
                                          .deleteAntrianPoli(data.id);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          }
        },
      ),
    );
  }

  /// Method buildImageBottom digunakan untuk membuat tampilan gambar pada halaman jadwal pemeriksaan pasien
  Widget buildImageBottom() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          child: Image.asset("assets/image/suster3.png"),
        ),
      ),
    );
  }
}
