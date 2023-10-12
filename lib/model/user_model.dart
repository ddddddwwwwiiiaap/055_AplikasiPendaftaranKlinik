/// Nama Module: user_model.dart
/// Deskripsi: Modul ini digunakan untuk membuat model user
/// 
/// Kode ini berisi implementasi model user

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// UserModel class adalah class yang digunakan untuk membuat model user
class UserModel {
  /// String uId adalah variabel yang digunakan untuk menyimpan id user
  String uId;
  /// String nama adalah variabel yang digunakan untuk menyimpan nama user
  String nama;
  /// String email adalah variabel yang digunakan untuk menyimpan email user
  String email;
  /// String role adalah variabel yang digunakan untuk menyimpan role user
  String role;
  /// String nomorhp adalah variabel yang digunakan untuk menyimpan nomor hp user
  String nomorhp;
  /// String tglLahir adalah variabel yang digunakan untuk menyimpan tanggal lahir user
  String tglLahir;
  /// String alamat adalah variabel yang digunakan untuk menyimpan alamat user
  String alamat;
  /// int noAntrian adalah variabel yang digunakan untuk menyimpan nomor antrian user
  int noAntrian;
  /// String poli adalah variabel yang digunakan untuk menyimpan poli user
  String poli;
  /// UserModel({required String uId, required String nama, required String email, required String role, required String nomorhp, required String tglLahir, required String alamat, required int noAntrian, required String poli}) digunakan untuk mengatur model user yang akan disimpan ke firebase
  UserModel({
    required this.uId,
    required this.nama,
    required this.email,
    required this.role,
    required this.nomorhp,
    required this.tglLahir,
    required this.alamat,
    required this.noAntrian,
    required this.poli,
  });

  /// Method toMap digunakan untuk mengubah data dari firebase menjadi data yang dapat dibaca oleh aplikasi
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'nama': nama,
      'email': email,
      'role': role,
      'nomorhp': nomorhp,
      'tglLahir': tglLahir,
      'alamat': alamat,
      'noAntrian': noAntrian,
      'poli': poli,
    };
  }

  /// Method fromMap digunakan untuk mengubah data dari aplikasi menjadi data yang dapat dibaca oleh firebase
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] as String,
      nama: map['nama'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      nomorhp: map['nomorhp'] as String,
      tglLahir: map['tglLahir'] as String,
      alamat: map['alamat'] as String,
      noAntrian: map['noAntrian'] as int,
      poli: map['poli'] as String,
    );
  }

  /// Method toJson digunakan untuk mengubah data dari aplikasi menjadi data yang dapat dibaca oleh firebase
  String toJson() => json.encode(toMap());

  /// Method fromJson digunakan untuk mengubah data dari firebase menjadi data yang dapat dibaca oleh aplikasi
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
