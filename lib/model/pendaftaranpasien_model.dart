// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PendaftaranPasienModel {
  String? uId;
  int noAntrian;
  String status;
  String waktuantrian;
  String tanggalantrian;
  String poli;
  PendaftaranPasienModel({
    this.uId,
    required this.noAntrian,
    required this.status,
    required this.waktuantrian,
    required this.tanggalantrian,
    required this.poli,
  });

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

  String toJson() => json.encode(toMap());

  factory PendaftaranPasienModel.fromJson(String source) => PendaftaranPasienModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
