import 'package:cmlabs_connect/src/models/client_pic_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientPicController extends GetxController {
  var search = Rx<String?>(null);

  /*

    CLIENT PIC DATA
    - single selected PICClient
    - nameEditingController
    - positionEditingController

  */

  var selectedPICClient = RxList<ClientPic>([]);
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> positionControllers = [];

  /*

    CONTACT of CLIENT PIC DATA
    - type
    - status
    - detail
    - info
    - note

  */

  final selectedContactType = Rx<List<List<Map<String, String>?>>>([]);
  final selectedContactStatus = Rx<List<List<Map<String, String>?>>>([]);
  final selectedDetailStatus = Rx<List<List<Map<String, String>?>>>([]);
  var infoContact = Rx<List<List<TextEditingController?>?>>([]);
  var noteContact = Rx<List<List<TextEditingController?>?>>([]);

  Future<void> loadData(List<ClientPic?> clientPIC) async {
    selectedPICClient.clear();
    nameControllers.clear();
    positionControllers.clear();
    selectedContactType.value.clear();
    selectedContactStatus.value.clear();
    selectedDetailStatus.value.clear();
    infoContact.value.clear();
    noteContact.value.clear();

    if (clientPIC.length != 0) {
      // Tambahkan data ke RxList dan inisialisasi controller
      for (var pic in clientPIC) {
        var dataClientPic = ClientPic(
          name: pic?.name ?? '',
          position: pic?.position ?? '',
          contacts: pic?.contacts ?? [],
        );
        selectedPICClient.add(dataClientPic);

        // Inisialisasi TextEditingController
        nameControllers.add(TextEditingController(text: dataClientPic.name));
        positionControllers
            .add(TextEditingController(text: dataClientPic.position));

        List<Map<String, String>?> contactTypes = [];
        List<Map<String, String>?> contactStatuses = [];
        List<Map<String, String>?> contactDetails = [];
        List<TextEditingController?> infoControllers = [];
        List<TextEditingController?> noteControllers = [];

        for (var contact in dataClientPic.contacts) {
          contactTypes.add({"value": contact?.type ?? '', "label": contact?.type ?? ''});
          contactStatuses.add({"value": contact?.status ?? '', "label": contact?.status ?? ''});
          contactDetails.add({"value": contact?.detail ?? '', "label": contact?.detail ?? ''});
          infoControllers.add(TextEditingController(text: contact?.info));
          noteControllers.add(TextEditingController(text: contact?.note));
        }

        // Menyimpan data kontak ke dalam list yang sesuai
        selectedContactType.value.add(contactTypes);
        selectedContactStatus.value.add(contactStatuses);
        selectedDetailStatus.value.add(contactDetails);
        infoContact.value.add(infoControllers);
        noteContact.value.add(noteControllers);
      }
    } else {
      // Jika tidak ada data, tambahkan satu data default
      selectedPICClient.add(ClientPic(name: '', position: '', contacts: []));
      nameControllers.add(TextEditingController());
      positionControllers.add(TextEditingController());

      selectedContactType.value.add([]);
      selectedContactStatus.value.add([]);
      selectedDetailStatus.value.add([]);
      infoContact.value.add([]);
      noteContact.value.add([]);
    }

    // // Debugging
    // print("Jumlah Client PIC: ${selectedPICClient.length}");
    // for (var i = 0; i < selectedPICClient.length; i++) {
    //   print(
    //       "PIC $i: ${selectedPICClient[i].name}, ${selectedPICClient[i].position}");
    // }
  }

  void updateClientPic(int index, String name, String position) {
    if (index < selectedPICClient.length) {
      // Menggunakan copyWith untuk memperbarui nama dan posisi
      selectedPICClient[index] =
          selectedPICClient[index].copyWith(name: name, position: position);
    }
  }

  // Panggil fungsi ini saat ada perubahan di TextField
  void onNameChanged(int index) {
    updateClientPic(
        index, nameControllers[index].text, selectedPICClient[index].position!);
  }

  void onPositionChanged(int index) {
    updateClientPic(
        index, selectedPICClient[index].name!, positionControllers[index].text);
  }

  void updateContactPic(int clientIndex, int contactIndex, String type,
      String info, String status, String detail, String note) {
    if (clientIndex < selectedPICClient.length) {
      var clientPic = selectedPICClient[clientIndex];
      var updatedContacts = List<ContactClientPic>.from(clientPic.contacts);
      updatedContacts[contactIndex] = updatedContacts[contactIndex].copyWith(
          type: type, info: info, status: status, detail: detail, note: note);
      selectedPICClient[clientIndex] =
          clientPic.copyWith(contacts: updatedContacts);
    }
  }

  void clearData() {
    // Clear RxList dan dispose TextEditingController untuk menghindari memory leaks
    selectedPICClient.clear();
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in positionControllers) {
      controller.dispose();
    }
    nameControllers.clear();
    positionControllers.clear();

    // Clear semua data kontak
    selectedContactType.value.clear();
    selectedContactStatus.value.clear();
    selectedDetailStatus.value.clear();
    infoContact.value.clear();
    noteContact.value.clear();

    // Clear search
    search.value = null;

    selectedPICClient.add(ClientPic(name: '', position: '', contacts: []));
    nameControllers.add(TextEditingController());
    positionControllers.add(TextEditingController());

    selectedContactType.value.add([]);
    selectedContactStatus.value.add([]);
    selectedDetailStatus.value.add([]);
    infoContact.value.add([]);
    noteContact.value.add([]);

    // Debugging untuk memastikan data benar-benar kosong
    print("Data telah direset.");
  }

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

    selectedContactType.value.add([]);
    selectedContactStatus.value.add([]);
    selectedDetailStatus.value.add([]);
    infoContact.value.add([]);
    noteContact.value.add([]);

    syncClientPIC();
  }

  void removePICClient(int index) {
    selectedPICClient.removeAt(index);
    nameControllers.removeAt(index);
    positionControllers.removeAt(index);
    selectedContactType.value.removeAt(index);
    selectedContactStatus.value.removeAt(index);
    selectedDetailStatus.value.removeAt(index);
    infoContact.value.removeAt(index);
    noteContact.value.removeAt(index);
    syncClientPIC();
  }

  void addContactPIC(int clientIndex, ContactClientPic contact) {
    if (clientIndex < selectedContactStatus.value.length) {
      selectedPICClient[clientIndex].contacts.add(contact);

      selectedContactStatus.value[clientIndex].add({'value': contact.status ?? '', 'label': contact.status ?? ''});
      selectedContactType.value[clientIndex].add({'value': contact.type ?? '', 'label': contact.type ?? ''});
      selectedDetailStatus.value[clientIndex].add({'value': contact.detail ?? '', 'label': contact.detail ?? ''});
      infoContact.value[clientIndex]
          ?.add(TextEditingController(text: contact.info));
      noteContact.value[clientIndex]
          ?.add(TextEditingController(text: contact.note));
    }
  }

  void removeContactPIC(int clientIndex, int contactIndex) {
    if (clientIndex < selectedContactStatus.value.length &&
        contactIndex < selectedContactStatus.value[clientIndex].length) {
      // selectedPICClient[clientIndex].contacts.removeAt(contactIndex);
      selectedContactStatus.value[clientIndex].removeAt(contactIndex);
      selectedContactType.value[clientIndex].removeAt(contactIndex);
      selectedDetailStatus.value[clientIndex].removeAt(contactIndex);
      infoContact.value[clientIndex]?.removeAt(contactIndex);
      noteContact.value[clientIndex]?.removeAt(contactIndex);
    }
  }

  void addContactType(int clientIndex, int contactIndex, Map<String, String> data){
    selectedContactType.value[clientIndex][contactIndex] = data;
  }
}
