import 'package:get/get.dart';
import 'package:quotation_app/src/models/client_source_model.dart';

class ClientSourceController extends GetxController{
  List<ClientSource> listSource = [
    ClientSource(id: 1, name: 'Direct Email'),
    ClientSource(id: 2, name: 'Web WhatsApp'),
    ClientSource(id: 3, name: 'Direct Linkedin'),
    ClientSource(id: 4, name: 'Direct Call'),
    ClientSource(id: 5, name: 'Referral'),
  ];

  List<ClientSource> get getListClientSource {
    return listSource;
  }
}