import 'package:aplikasipendaftaranklinik/controller/poli_controller.dart';
import 'package:aplikasipendaftaranklinik/model/poli_model.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/admin/poli/add_poli.dart';
import 'package:aplikasipendaftaranklinik/view/admin/poli/update_poli.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Poli extends StatefulWidget {
  const Poli({super.key});

  @override
  State<Poli> createState() => _PoliState();
}

class _PoliState extends State<Poli> {
  var pc = PoliController();

  @override
  void initState() {
    // TODO: implement initState
    pc.getPoli();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade100, Colors.pink.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.pink,
                height: 50,
                width: double.infinity,
                //buat teks ditengah dan gambar di kanan
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      'https://icon-library.com/images/clinic-icon/clinic-icon-28.jpg',
                      height: 100,
                      width: 100,
                    ),
                    const Text(
                      textPoli,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Image.network(
                      'https://icon-library.com/images/clinic-icon/clinic-icon-28.jpg',
                      height: 100,
                      width: 100,
                    ),
                  ],
                ),
              ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdatePoli(
                                    poliModel: PoliModel.fromMap(
                                        data[index].data()
                                            as Map<String, dynamic>),
                                    contact: data[index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 10,
                              shadowColor: Colors.cyan,
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.pink,
                                    child: Text(
                                        data[index]['namaPoli']
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                title: Text(data[index]['namaPoli']),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPoli(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
