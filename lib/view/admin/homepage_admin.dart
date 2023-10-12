/// Nama Module : Home Page Admin
/// Deskripsi : Modul ini digunakan untuk menampilkan halaman home admin
/// 
/// Kode ini berisi implementasi tampilan dan logika untuk halaman home admin

import 'package:aplikasipendaftaranklinik/controller/auth_controller.dart';
import 'package:aplikasipendaftaranklinik/model/user_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/admin/daftar_antrian_a.dart';
import 'package:aplikasipendaftaranklinik/view/admin/poli/poli.dart';
import 'package:aplikasipendaftaranklinik/view/admin/profile_admin.dart';
import 'package:aplikasipendaftaranklinik/view/admin/riwayat_pasien_masuk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// HomePageAdmin class adalah widget yang digunakan untuk membuat tampilan halaman home admin
class HomePageAdmin extends StatefulWidget {
  /// Fungsi HomePageAdmin({Key? key}) adalah konstruktor dari class HomePageAdmin yang menerima parameter key dengan tipe Key yang bersifat opsional
  /// Fungsi ini akan dijalankan ketika class HomePageAdmin dipanggil
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

/// _HomePageAdminState class adalah class yang digunakan untuk menampilkan halaman home admin
class _HomePageAdminState extends State<HomePageAdmin> {
  final Stream<QuerySnapshot> streamAntrianPasien =
      FirebaseFirestore.instance.collection('antrian pasien').snapshots();
  var auth = AuthController(isEdit: false);

  String? uId;
  String? nama;
  String? email;
  String? role;
  String? nomorhp;
  String? tglLahir;
  String? alamat;

  /// Future getUser digunakan untuk mengambil data user dari database
  Future<UserModel?> getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (result) {
        if (result.docs.isNotEmpty) {
          setState(
            () {
              uId = result.docs[0].data()['uId'];
              nama = result.docs[0].data()['nama'];
              email = result.docs[0].data()['email'];
              role = result.docs[0].data()['role'];
              nomorhp = result.docs[0].data()['nomorhp'];
              tglLahir = result.docs[0].data()['tglLahir'];
              alamat = result.docs[0].data()['alamat'];
            },
          );
        }
      },
    );
    return null;
  }

  /// initState digunakan untuk menjalankan method getUser
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  /// showDialogExitToApp digunakan untuk menampilkan dialog konfirmasi keluar aplikasi
  showDialogExitToApp() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(titleLogout),
          content: const Text(contentLogout),
          actions: [
            TextButton(
              onPressed: () => auth.signOut(context),
              child: Text(
                textYa.toUpperCase(),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                textTidak.toUpperCase(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Method build digunakan untuk membuat tampilan halaman home admin
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleHome),
        actions: [
          IconButton(
            onPressed: showDialogExitToApp,
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: homeDrawer(),
      body: Stack(
          children: [
            buildIconHome(),
            buildTextTitle(),
            buildItemBody(size),
          ],
        ),
    );
  }

  /// Method homeDrawer digunakan untuk membuat tampilan drawer pada halaman home admin
  Widget homeDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorPrimary),
            child: Container(
              child: Center(
                child: ListTile(
                  leading: Image.asset("assets/image/profil.png"),
                  title: Text(
                    "$nama".toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "ID dr : ${uId?.substring(20, 27)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePageAdmin(),
              ),
            ),
            leading: Image.asset(
              "assets/icon/icon_home.png",
              width: 24,
            ),
            title: const Text(
              titleHome,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileAdmin(
                  uid: uId.toString(),
                  nama: nama.toString(),
                  email: email.toString(),
                  role: role.toString(),
                  nomorhp: nomorhp.toString(),
                  tglLahir: tglLahir.toString(),
                  alamat: alamat.toString(),
                  isEdit: true,
                ),
              ),
            ),
            leading: Image.asset(
              "assets/icon/icon_profile.png",
              width: 24,
            ),
            title: const Text(
              titleProfile,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Poli()),
            ),
            leading: Image.asset(
              "assets/icon/icon_poli.png",
              width: 24,
            ),
            title: const Text(
              titlePoli,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DaftarAntrianPagesAdmin()),
            ),
            leading: Image.asset(
              "assets/icon/icon_daftar_antrian.png",
              width: 24,
            ),
            title: const Text(
              titleDaftarAntrian,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const RiwayatPasienMasuk()),
            ),
            leading: Image.asset(
              "assets/icon/icon_history.png",
              width: 24,
            ),
            title: const Text(
              titleRiwayatPasienMasuk,
            ),
          ),
        ],
      ),
    );
  }

  /// Method buildIconHome digunakan untuk membuat tampilan icon pada halaman home admin
  Widget buildIconHome() {
    return Positioned(
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset("assets/image/hospital.png"),
      ),
    );
  }

  /// Method buildTextTitle digunakan untuk membuat tampilan text title pada halaman home admin
  Widget buildTextTitle() {
    return Positioned.fill(
      left: 16,
      top: 240,
      right: 0,
      bottom: 0,
      child: Text(
        "$textWelcome\n\nTetap Semangat Admin\n$nama",
        style: const TextStyle(
          fontSize: 20,
          color: colorPinkText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Method buildItemBody digunakan untuk membuat tampilan body pada halaman home admin
  Widget buildItemBody(Size size) {
    return Positioned(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, top: 140),
              width: size.width / 2,
              height: size.height / 7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorPinkText)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Jumlah Pasien Hari ini : ",
                    style: TextStyle(
                      color: colorPinkText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: streamAntrianPasien,
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
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              Text(
                                "${int.parse(totalAntrianPasien.toString())}",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: colorPinkText,
                                ),
                              ),
                              const Text(
                                "Orang",
                                style: TextStyle(color: colorPinkText),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, top: 100),
              child: Image.asset("assets/image/suster.png"),
            )
          ],
        ),
      ),
    );
  }
}
