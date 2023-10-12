/// Nama Module: poli.dart
/// Deskripsi: Modul ini digunakan untuk menampilkan data poli
/// 
/// Kode ini berisi implementasi tampilan dan logika untuk halaman data poli

import 'package:aplikasipendaftaranklinik/controller/poli_controller.dart';
import 'package:aplikasipendaftaranklinik/model/poli_model.dart';
import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/admin/homepage_admin.dart';
import 'package:aplikasipendaftaranklinik/view/admin/poli/add_poli.dart';
import 'package:aplikasipendaftaranklinik/view/admin/poli/update_poli.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Poli class adalah widget yang digunakan untuk membuat tampilan halaman data poli
class Poli extends StatefulWidget {
  ///const Poli({Key? key}) digunakan untuk membuat konstruktor dari class Poli yang menerima parameter key dengan tipe Key yang bersifat opsional
  ///Fungsi ini akan dijalankan ketika class Poli dipanggil
  const Poli({super.key});

  @override
  State<Poli> createState() => _PoliState();
}

/// _PoliState class adalah class yang digunakan untuk menampilkan halaman data poli
class _PoliState extends State<Poli> {
  var pc = PoliController();

  /// initState digunakan untuk menjalankan method getPoli
  @override
  void initState() {
    // TODO: implement initState
    pc.getPoli();
    super.initState();
  }

  /// Method build digunakan untuk membuat tampilan halaman data poli
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //membuat action button dibagian kiri atas
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePageAdmin(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          textPoli,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: pc.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<DocumentSnapshot> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onLongPress: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePoli(
                                  poliModel: PoliModel.fromMap(data[index]
                                      .data() as Map<String, dynamic>),
                                  poli: data[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.cyan,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: colorPrimary,
                                child: Text(
                                  data[index]['namaPoli']
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(data[index]['namaPoli']),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  //buat dialog delete data
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Data!'),
                                        content: const Text(
                                            'Are you sure want to delete this data?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              pc.poliCollection
                                                  .doc(data[index].id)
                                                  .delete();
                                              pc.getPoli();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Data has been deleted'),
                                                  duration:
                                                      Duration(seconds: 1),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPoli(),
            ),
          );
        },
        backgroundColor: colorButton,
        child: const Icon(Icons.add),
      ),
    );
  }
}
