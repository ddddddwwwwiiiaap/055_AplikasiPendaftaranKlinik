/// Nama Module: profile_pasien.dart
/// Deskripsi: Modul untuk layar profile pasien dalam aplikasi Flutter pendaftaran klinik.
/// 
/// Kode ini berisi implementasi tampilan dan logika untuk halaman profile pasien.

import 'package:aplikasipendaftaranklinik/controller/auth_controller.dart';
import 'package:aplikasipendaftaranklinik/model/user_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/pasien/homepage_pasien.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ProfilePasien class adalah widget yang digunakan untuk membuat tampilan halaman profile pasien
class ProfilePasien extends StatefulWidget {
  /// String? uid digunakan untuk menyimpan uid dari user
  String? uid;
  /// String? nama digunakan untuk menyimpan nama dari user
  String? nama;
  /// String? email digunakan untuk menyimpan email dari user
  String? email;
  /// String? role digunakan untuk menyimpan role dari user
  String? role;
  /// String? nomorhp digunakan untuk menyimpan nomorhp dari user
  String? nomorhp;
  /// String? tglLahir digunakan untuk menyimpan tglLahir dari user
  String? tglLahir;
  /// String? alamat digunakan untuk menyimpan alamat dari user
  String? alamat;
  /// bool isEdit digunakan untuk menyimpan status apakah user sedang mengedit profile atau tidak
  final bool isEdit;
  /// ProfilePasien({Key? key, this.uid, this.nama, this.email, this.role, this.nomorhp, this.tglLahir, this.alamat, required this.isEdit}) digunakan untuk membuat konstruktor dari class ProfilePasien yang menerima parameter key dengan tipe Key yang bersifat opsional, uid dengan tipe String yang bersifat opsional, nama dengan tipe String yang bersifat opsional, email dengan tipe String yang bersifat opsional, role dengan tipe String yang bersifat opsional, nomorhp dengan tipe String yang bersifat opsional, tglLahir dengan tipe String yang bersifat opsional, alamat dengan tipe String yang bersifat opsional, dan isEdit dengan tipe bool yang bersifat wajib
  ProfilePasien(
      {Key? key,
      this.uid,
      this.nama,
      this.email,
      this.role,
      this.nomorhp,
      this.tglLahir,
      this.alamat,
      required this.isEdit})
      : super(key: key);

  @override
  State<ProfilePasien> createState() => _ProfilePasienState();
}

/// _ProfilePasienState class adalah class yang digunakan untuk menampilkan halaman profile pasien
class _ProfilePasienState extends State<ProfilePasien> {
  var auth = AuthController(isEdit: true);
  String? uId;
  String? nama;
  String? email;
  String? nomorhp;
  String? tglLahir;
  String? alamat;

  final formKey = GlobalKey<FormState>();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nomorhp = TextEditingController();
  final TextEditingController _tglLahir = TextEditingController();
  final TextEditingController _alamat = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String? setDate, setTime;

  /// Future<Null> _selectDate digunakan untuk menampilkan date picker
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        tglLahir = DateFormat.yMd().format(selectedDate);
      });
  }

  /// initState digunakan untuk menginisialisasi state
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      setState(() {
        nama = widget.nama!;
        email = widget.email!;
        nomorhp = widget.nomorhp!;
        tglLahir = widget.tglLahir!;
        alamat = widget.alamat!;

        _nama.text = widget.nama!;
        _email.text = widget.email!;
        _nomorhp.text = widget.nomorhp!;
        _tglLahir.text = widget.tglLahir!;
        _alamat.text = widget.alamat!;
      });
    }
  }

  /// Method build digunakan untuk membuat tampilan halaman profile pasien
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        title: const Text(titleProfile),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(size),
              buildFormProfile(size),
              buildButtonSave()
            ],
          ),
        ),
      ),
    );
  }

  /// Method buildHeader digunakan untuk membuat tampilan header halaman profile pasien
  Widget buildHeader(Size size) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 40),
      child: Row(
        children: [
          Container(
            child: Stack(
              children: [
                Image.asset(
                  "assets/ellipse/ellipse1.png",
                  width: size.width / 1.8,
                ),
                const Positioned.fill(
                  left: 0,
                  top: 36,
                  right: 0,
                  bottom: 0,
                  child: Text(
                    textDeskripsiProfile,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Image.asset("assets/image/suster.png")
        ],
      ),
    );
  }

  /// Method buildFormProfile digunakan untuk membuat tampilan form profile pasien
  Widget buildFormProfile(Size size) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: TextFormField(
              controller: _nama,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(labelText: textNama),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Masukkan $textNama';
                } else {
                  return '$textNama Salah!';
                }
              },
              onChanged: (value) {
                setState(() {
                  nama = value;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: TextFormField(
              readOnly: true,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: textEmail,
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: _nomorhp,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: textNomorHP,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Masukkan $textNomorHP';
                } else {
                  return '$textNomorHP Salah!';
                }
              },
              onChanged: (value) {
                setState(() {
                  nomorhp = value;
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
            child: Text(
              textTglLahir,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 99, 98, 98),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              width: size.width,
              margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: colorButtonHome),
              child: TextFormField(
                style: const TextStyle(fontSize: 18),
                enabled: false,
                keyboardType: TextInputType.text,
                onSaved: (String? val) {
                  setDate = val!;
                },
                onChanged: (String? val) {
                  setDate = val!;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.calendar_month,
                    color: colorPrimary,
                  ),
                  hintText: tglLahir,
                  disabledBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(top: 12),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: TextFormField(
              controller: _alamat,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: textAlamat,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Masukkan $textAlamat';
                } else {
                  return '$textAlamat Salah!';
                }
              },
              onChanged: (value) {
                setState(() {
                  alamat = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  /// Method buildButtonSave digunakan untuk membuat tampilan button save
  Widget buildButtonSave() {
    return ElevatedButton(
      onPressed: () async {
        UserModel? profilePasien = await auth.updateProfilePasien(
          nama!,
          email!,
          nomorhp!,
          tglLahir!,
          alamat!,
          context,
        );
        if (profilePasien != null) {}
      },
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(colorButton),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      child: Container(
        width: 120,
        height: 40,
        child: const Center(
          child: Text(
            textButtonSave,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
