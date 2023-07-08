import 'package:aplikasipendaftaranklinik/themes/custom_colors.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AntrianPages extends StatefulWidget {
  int? noAntrian;
  String? poli;
  AntrianPages({Key? key, this.noAntrian, this.poli}) : super(key: key);

  @override
  State<AntrianPages> createState() => _AntrianPagesState();
}

class _AntrianPagesState extends State<AntrianPages> {
  final Stream<QuerySnapshot> _streamAntrianPasien =
      FirebaseFirestore.instance.collection("antrian pasien").snapshots();

  int? noAntrianSedangDilayani = 25;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("antrian pasien")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        noAntrianSedangDilayani = doc['noantrian'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorButtonHome,
      appBar: AppBar(
        title: const Text(titleAntrian),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            buildItemAntrian(size),
          ],
        ),
      ),
    );
  }

  Widget buildItemAntrian(Size size) {
    return Column(
      children: [
        
          Container(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 10),
            width: size.width,
            height: size.height / 5,
            decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  textSedangDilayani,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  "${widget.noAntrian}",
                  style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          ),
        
        Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 0, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorButtonHome),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    textNoAntrian,
                    style: TextStyle(color: colorPinkText, fontSize: 12),
                  ),
                  Text(
                    "${widget.noAntrian}",
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorPinkText),
                  )
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _streamAntrianPasien,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error!"),
                    );
                  } else {
                    int sisaAntrian = int.parse("${noAntrianSedangDilayani}") -
                        int.parse("${widget.noAntrian}");
                    return Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            textSisaAntrian,
                            style:
                                TextStyle(color: colorPinkText, fontSize: 12),
                          ),
                          Text(
                            "${int.parse(sisaAntrian.toString())}",
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colorPinkText),
                          )
                        ],
                      ),
                    );
                  }
                }),
            StreamBuilder<QuerySnapshot>(
                stream: _streamAntrianPasien,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error!"),
                    );
                  } else {
                    int totalAntrianPasien = snapshot.data!.docs.length;
                    return Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            textJumlahPendaftar,
                            style:
                                TextStyle(color: colorPinkText, fontSize: 12),
                          ),
                          Text(
                            "${int.parse(totalAntrianPasien.toString())}",
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colorPinkText),
                          )
                        ],
                      ),
                    );
                  }
                }),
          ],
        )
      ],
    );
  }
}