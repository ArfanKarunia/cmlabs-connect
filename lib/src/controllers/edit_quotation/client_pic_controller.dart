import 'package:cmlabs_connect/src/models/client_pic_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientPicController extends GetxController{
  /*

    CLIENT PIC DATA
    - single selected PICClient
    - nameEditingController
    - positionEditingController

  */

  final RxList<ClientPic> selectedPICClient = [
    ClientPic(name: '', position: '', contacts: []),
  ].obs;

  List<TextEditingController> nameControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> positionControllers = [
    TextEditingController(),
  ];

  // Memastikan jumlah controller sesuai dengan jumlah data
  void syncClientPIC() {
    nameControllers = selectedPICClient
        .map((pic) => TextEditingController(text: pic.name))
        .toList();
    positionControllers = selectedPICClient
        .map((pic) => TextEditingController(text: pic.position))
        .toList();
  }

  // CLient PIC
  void addPICClient() {
    selectedPICClient.add(ClientPic(name: '', position: '', contacts: []));
    nameControllers.add(TextEditingController());
    positionControllers.add(TextEditingController());
    syncClientPIC();
  }

  void removePICClient(int index) {
    selectedPICClient.removeAt(index);
    nameControllers.removeAt(index);
    positionControllers.removeAt(index);
    syncClientPIC();
  }

  
}