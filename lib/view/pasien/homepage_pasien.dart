import 'package:aplikasipendaftaranklinik/controller/auth_controller.dart';
import 'package:aplikasipendaftaranklinik/model/user_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/jadwal_pemeriksaan.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/pendaftaran.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/profile_pasien.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePagePasien extends StatefulWidget {
  const HomePagePasien({super.key});

  @override
  State<HomePagePasien> createState() => _HomePagePasienState();
}

class _HomePagePasienState extends State<HomePagePasien> {
  var auth = AuthController(isEdit: false);
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
              noAntrian = result.docs[0].data()['noantrian'];
              poli = result.docs[0].data()['poli'];
            },
          );
        }
      },
    );
    return null;
  }

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
          ],
        ),
      ),
    );
  }

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
                    "$nama",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
            onTap: () => Navigator.push(context,
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
            onTap: () => Navigator.push(
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
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Pendaftaran(
                          uId: uId.toString(),
                          nama: nama.toString(),
                        ))),
            leading: Image.asset(
              "assets/icon/icon_daftar_antrian.png",
              width: 24,
            ),
            title: const Text(
              titleDaftarAntrian,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
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
        ],
      ),
    );
  }

  Widget buildBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height / 3.78,
      color: colorHome,
    );
  }

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

  Widget buildHeader(Size size) {
    return Image.asset(
      "assets/image/vector.png",
      width: size.width,
      height: size.height / 3,
    );
  }

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
}
