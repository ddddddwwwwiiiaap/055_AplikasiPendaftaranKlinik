// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String uId;
  String nama;
  String email;
  String role;
  String nomorhp;
  String jekel;
  String tglLahir;
  String alamat;
  int noAntrian;
  String poli;
  UserModel({
    required this.uId,
    required this.nama,
    required this.email,
    required this.role,
    required this.nomorhp,
    required this.jekel,
    required this.tglLahir,
    required this.alamat,
    required this.noAntrian,
    required this.poli,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'nama': nama,
      'email': email,
      'role': role,
      'nomorhp': nomorhp,
      'jekel': jekel,
      'tglLahir': tglLahir,
      'alamat': alamat,
      'noAntrian': noAntrian,
      'poli': poli,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] as String,
      nama: map['nama'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      nomorhp: map['nomorhp'] as String,
      jekel: map['jekel'] as String,
      tglLahir: map['tglLahir'] as String,
      alamat: map['alamat'] as String,
      noAntrian: map['noAntrian'] as int,
      poli: map['poli'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
