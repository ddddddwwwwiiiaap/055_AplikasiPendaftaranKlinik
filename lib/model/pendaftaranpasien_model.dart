/// Nama Module: pendaftaranpasien_model.dart
/// Deskripsi: Modul ini digunakan untuk membuat model pendaftaran pasien
/// 
/// Kode ini berisi implementasi model pendaftaran pasien

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// PendaftaranPasienModel class adalah class yang digunakan untuk membuat model pendaftaran pasien
class PendaftaranPasienModel {
  /// uId adalah variabel yang digunakan untuk menyimpan id user
  String? uId;
  /// int noAntrian adalah variabel yang digunakan untuk menyimpan nomor antrian
  int noAntrian;
  /// String status adalah variabel yang digunakan untuk menyimpan status
  String status;
  /// String waktuantrian adalah variabel yang digunakan untuk menyimpan waktu antrian
  String waktuantrian;
  /// String tanggalantrian adalah variabel yang digunakan untuk menyimpan tanggal antrian
  String tanggalantrian;
  /// String poli adalah variabel yang digunakan untuk menyimpan nama poli
  String poli;

///PendaftaranPasienModel({String? uId, required int noAntrian, required String status, required String waktuantrian, required String tanggalantrian, required String poli}) digunakan untuk mengatur model pendaftaran pasien yang akan disimpan ke firebase
  PendaftaranPasienModel({
    this.uId,
    required this.noAntrian,
    required this.status,
    required this.waktuantrian,
    required this.tanggalantrian,
    required this.poli,
  });

/// Map<String, dynamic> toMap() digunakan untuk mengubah data pendaftaran pasien menjadi map agar dapat disimpan ke firebase
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'noAntrian': noAntrian,
      'status': status,
      'waktuantrian': waktuantrian,
      'tanggalantrian': tanggalantrian,
      'poli': poli,
    };
  }

/// PendaftaranPasienModel.fromMap(Map<String, dynamic> map) digunakan untuk mengubah map menjadi data pendaftaran pasien
  factory PendaftaranPasienModel.fromMap(Map<String, dynamic> map) {
    return PendaftaranPasienModel(
      uId: map['uId'] != null ? map['uId'] as String : null,
      noAntrian: map['noAntrian'] as int,
      status: map['status'] as String,
      waktuantrian: map['waktuantrian'] as String,
      tanggalantrian: map['tanggalantrian'] as String,
      poli: map['poli'] as String,
    );
  }

/// String toJson() digunakan untuk mengubah data pendaftaran pasien menjadi json agar dapat disimpan ke firebase
  String toJson() => json.encode(toMap());

/// PendaftaranPasienModel.fromJson(String source) digunakan untuk mengubah json menjadi data pendaftaran pasien
  factory PendaftaranPasienModel.fromJson(String source) => PendaftaranPasienModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
