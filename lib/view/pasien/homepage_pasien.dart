/// Nama Module : homepage_pasien.dart
/// Deskripsi : Modul ini digunakan untuk menampilkan halaman utama pasien
/// 
/// Kode ini berisi implementasi tampilan dan logika untuk halaman utama pasien

import 'package:aplikasipendaftaranklinik/controller/auth_controller.dart';
import 'package:aplikasipendaftaranklinik/model/user_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/antrian.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/jadwal_pemeriksaan.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/pendaftaran.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/profile_pasien.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/riwayat_pemeriksaan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// HomePagePasien class adalah widget yang digunakan untuk membuat tampilan halaman utama pasien
class HomePagePasien extends StatefulWidget {
  /// Fungsi HomePagePasien({Key? key}) adalah konstruktor dari class HomePagePasien yang menerima parameter key dengan tipe Key yang bersifat opsional
  /// Fungsi ini akan dijalankan ketika class HomePagePasien dipanggil
  const HomePagePasien({super.key});

  @override
  State<HomePagePasien> createState() => _HomePagePasienState();
}

/// _HomePagePasienState class adalah class yang digunakan untuk menampilkan halaman utama pasien
class _HomePagePasienState extends State<HomePagePasien> {
  var auth = AuthController(isEdit: false);
  var pendaftaran = Pendaftaran();
  String? uId;
  String? nama;
  String? email;
  String? role;
  String? nomorhp;
  String? jekel;
  String? tglLahir;
  String? alamat;
  int? noAntrian;
  String? poli;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  /// checkAndResetAntrian digunakan untuk mengecek dan mereset antrian
  void checkAndResetAntrian() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    if (currentHour >= 20 && currentHour <= 24 ||
        currentHour >= 00 && currentHour < 6) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Pendaftaran Tidak Tersedia'),
            content: const Text(
                'Maaf, pendaftaran hanya tersedia dari pukul 06.00 hingga 19.59.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else if (noAntrian != null && noAntrian! >= 25) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Pendaftaran Tidak Tersedia'),
            content: const Text(
                'Maaf, nomor antrian telah mencapai batas maksimum.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Pendaftaran(
            uId: uId,
            nama: nama,
          ),
        ),
      );
    }
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
            )
          ],
        );
      },
    );
  }

  /// Future getUser digunakan untuk mendapatkan data user dari database
  Future<void> getUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          uId = result.docs[0].data()['uId'];
          nama = result.docs[0].data()['nama'];
          email = result.docs[0].data()['email'];
          role = result.docs[0].data()['role'];
          nomorhp = result.docs[0].data()['nomorhp'];
          tglLahir = result.docs[0].data()['tglLahir'];
          alamat = result.docs[0].data()['alamat'];
          noAntrian = result.docs[0].data()['noAntrian'];
          poli = result.docs[0].data()['poli'];
        });

        // Cek waktu saat ini
        DateTime now = DateTime.now();
        int currentHour = now.hour;

        // Reset nomor antrian jika sudah melewati pukul 23.00 sampai 05.59
        if (currentHour >= 23 && currentHour <= 24 ||
            currentHour >= 00 && currentHour < 6) {
          resetNoAntrian();
        }
      }
    });
  }

  /// Future resetNoAntrian digunakan untuk mereset nomor antrian
  Future<void> resetNoAntrian() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update({'noAntrian': 0});

    setState(() {
      noAntrian = 0;
    });
  }

  /// Method build digunakan untuk membuat tampilan halaman utama pasien
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
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            buildBackground(size),
            buildHeader(size),
            buildTitleHeader(),
            buildIconHome(),
            noAntrian == 0
                ? buildButtonAmbilNoAntrian()
                : buildButtonLihatAntrian(size)
          ],
        ),
      ),
    );
  }

  /// Method homeDrawer digunakan untuk membuat tampilan drawer pada halaman utama pasien
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "No. Akun : ${uId?.substring(20, 27)}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const HomePagePasien())),
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
                builder: (_) => ProfilePasien(
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
            onTap: checkAndResetAntrian,
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
                    builder: (_) =>
                        JadwalPemeriksaanPages(uid: uId.toString()))),
            leading: Image.asset(
              "assets/icon/icon_jadwal_periksa.png",
              width: 24,
            ),
            title: const Text(
              titleJadwalPemeriksaan,
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => RiwayatPemeriksaanPages(
                          uid: uId.toString(),
                        ))),
            leading: Image.asset(
              "assets/icon/icon_history.png",
              width: 24,
            ),
            title: const Text(
              titleRiwayatPemeriksaan,
            ),
          ),
        ],
      ),
    );
  }

  /// Method buildBackground digunakan untuk membuat tampilan background pada halaman utama pasien
  Widget buildBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height / 3.78,
      color: colorHome,
    );
  }

  /// Method buildTitleHeader digunakan untuk membuat tampilan title pada halaman utama pasien
  Widget buildTitleHeader() {
    return Positioned.fill(
      top: 40,
      left: 40,
      right: 0,
      bottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              textWelcome,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          Text(
            "Semoga Lekas Sembuh\n$nama",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          )
        ],
      ),
    );
  }

  /// Method buildHeader digunakan untuk membuat tampilan header pada halaman utama pasien
  Widget buildHeader(Size size) {
    return Image.asset(
      "assets/image/vector.png",
      width: size.width,
      height: size.height / 3,
    );
  }

  /// Method buildIconHome digunakan untuk membuat tampilan icon rumah sakit pada halaman utama pasien
  Widget buildIconHome() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(bottom: 90),
          child: Image.asset("assets/image/home_doctor.png"),
        ),
      ),
    );
  }

  /// Method buildButtonAmbilNoAntrian digunakan untuk membuat tampilan button ambil nomor antrian pada halaman utama pasien
  Widget buildButtonAmbilNoAntrian() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 90),
          child: ElevatedButton(
              onPressed: checkAndResetAntrian,
              style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(colorButtonHome),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: Text(
                  textButtonAntrian,
                  style: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  /// Method buildButtonLihatAntrian digunakan untuk membuat tampilan button lihat nomor antrian pada halaman utama pasien
  Widget buildButtonLihatAntrian(Size size) {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset("assets/ellipse/ellipse8.png"),
                    Image.asset("assets/image/suster.png"),
                  ],
                )),
            Container(
                width: size.width / 1.4,
                margin: const EdgeInsets.only(bottom: 160),
                child: const Row(
                  children: [
                    Text(
                      titleNoAntrian,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
                width: size.width / 2.5,
                margin: const EdgeInsets.only(bottom: 80),
                child: Row(
                  children: [
                    Text(
                      noAntrian == null ? "" : "${noAntrian ?? "-"}",
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 120),
              child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AntrianPages(noAntrian: noAntrian, poli: poli))),
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(colorButtonHome),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)))),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                    child: Text(
                      textButtonLihatAntrian,
                      style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
