/// Nama Module: poli_model.dart
/// Deskripsi: Modul ini digunakan untuk membuat model poli
///
/// Kode ini berisi implementasi model poli

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PoliModel {
  /// String? uId adalah variabel yang digunakan untuk menyimpan id user
  String? uId;

  /// String namaPoli adalah variabel yang digunakan untuk menyimpan nama poli
  final String namaPoli;

  ///PoliModel({String? uId, required String namaPoli}) digunakan untuk mengatur model poli yang akan disimpan ke firebase
  PoliModel({
    this.uId,
    required this.namaPoli,
  });

  /// Map<String, dynamic> toMap() digunakan untuk mengubah data poli menjadi map agar dapat disimpan ke firebase
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'namaPoli': namaPoli,
    };
  }

  /// PoliModel.fromMap(Map<String, dynamic> map) digunakan untuk mengubah map menjadi data poli
  factory PoliModel.fromMap(Map<String, dynamic> map) {
    return PoliModel(
      uId: map['uId'] != null ? map['uId'] as String : null,
      namaPoli: map['namaPoli'] as String,
    );
  }

  /// String toJson() digunakan untuk mengubah data poli menjadi json agar dapat disimpan ke firebase
  String toJson() => json.encode(toMap());

  /// PoliModel.fromJson(String source) digunakan untuk mengubah json menjadi data poli
  factory PoliModel.fromJson(String source) =>
      PoliModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
