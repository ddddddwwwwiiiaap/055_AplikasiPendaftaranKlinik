/// Nama Module: riwayatpasienmasuk_model.dart
/// Deskripsi: Modul ini digunakan untuk membuat model riwayat pasien masuk
/// 
/// Kode ini berisi implementasi model riwayat pasien masuk

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// RiwayatPasienMasukModel class adalah class yang digunakan untuk membuat model riwayat pasien masuk
class RiwayatPasienMasukModel {
  /// String uId adalah variabel yang digunakan untuk menyimpan id user
  String uId;
  /// String selesaiantrian adalah variabel yang digunakan untuk menyimpan status selesai antrian
  String selesaiantrian;
  ///RiwayatPasienMasukModel({required String uId, required String selesaiantrian}) digunakan untuk mengatur model riwayat pasien masuk yang akan disimpan ke firebase
  RiwayatPasienMasukModel({
    required this.uId,
    required this.selesaiantrian,
  });

  /// Method toMap digunakan untuk mengubah data dari firebase menjadi data yang dapat dibaca oleh aplikasi
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'selesaiantrian': selesaiantrian,
    };
  }

  /// Method fromMap digunakan untuk mengubah data dari aplikasi menjadi data yang dapat dibaca oleh firebase
  factory RiwayatPasienMasukModel.fromMap(Map<String, dynamic> map) {
    return RiwayatPasienMasukModel(
      uId: map['uId'] as String,
      selesaiantrian: map['selesaiantrian'] as String,
    );
  }

  /// Method toJson digunakan untuk mengubah data dari aplikasi menjadi data yang dapat dibaca oleh firebase
  String toJson() => json.encode(toMap());

  /// Method fromJson digunakan untuk mengubah data dari firebase menjadi data yang dapat dibaca oleh aplikasi
  factory RiwayatPasienMasukModel.fromJson(String source) => RiwayatPasienMasukModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
