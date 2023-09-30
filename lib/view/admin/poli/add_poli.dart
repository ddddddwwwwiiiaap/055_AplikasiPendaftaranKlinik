import 'package:aplikasipendaftaranklinik/controller/poli_controller.dart';
import 'package:aplikasipendaftaranklinik/model/poli_model.dart';
import 'package:aplikasipendaftaranklinik/themes/material_colors.dart';
import 'package:aplikasipendaftaranklinik/utils/constants.dart';
import 'package:aplikasipendaftaranklinik/view/admin/poli/poli.dart';
import 'package:flutter/material.dart';

class AddPoli extends StatefulWidget {
  const AddPoli({super.key});

  @override
  State<AddPoli> createState() => _AddPoliState();
}

class _AddPoliState extends State<AddPoli> {
  var poliController = PoliController();
  final formKey = GlobalKey<FormState>();
  String? namaPoli;

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
                builder: (context) => const Poli(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(textAddPoli),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const CircleAvatar(
                          radius: 25,
                          child: Icon(
                            Icons.person,
                            size: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Poli',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter poly name';
                            }
                            return null;
                          },
                          onChanged: (value) => namaPoli = value,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: const Text('Add Poli'),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              PoliModel cm = PoliModel(
                                namaPoli: namaPoli!,
                              );
                              poliController.addPoli(cm).then(
                                (value) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Poli(),
                                    ),
                                  );
                                },
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Poli Added'),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
