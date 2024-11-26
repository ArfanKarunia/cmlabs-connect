import 'package:cmlabs_connect/src/controllers/edit_quotation/client_pic_controller.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/select_field_edit_quotation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_buttom.dart';

class ClientSidePICSection extends StatelessWidget {
  ClientSidePICSection({
    super.key,
  });

  final ClientPicController clientPicController = Get.put(ClientPicController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PIC (Client Side)",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text_1,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Obx(
            () {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: clientPicController.selectedPICClient.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var clientPic = clientPicController.selectedPICClient[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (clientPicController.selectedPICClient.length > 1)
                                ? "PIC ${index + 1} Name"
                                : "PIC Name",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text_3,
                            ),
                          ),
                          (clientPicController.selectedPICClient.length > 1)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: CustomButton(
                                    backgroundColor: Colors.transparent,
                                    onPressed: () {
                                      clientPicController.removePICClient(index);
                                      clientPicController.selectedPICClient.refresh();
                                    },
                                    child: Icon(
                                      Ionicons.trash_outline,
                                      color: AppColors.danger,
                                      size: 18,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: clientPicController.nameControllers[index],
                        onChanged: (value) {
                          clientPicController.selectedPICClient[index] = clientPicController
                              .selectedPICClient[index]
                              .copyWith(name: value);
                        },
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.text_1,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text_4),
                          hintText: "PIC Name",
                          errorStyle: GoogleFonts.plusJakartaSans(
                              color: AppColors.danger,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Position",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_3,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: clientPicController.positionControllers[index],
                        onChanged: (value) {
                          clientPicController.selectedPICClient[index] = clientPicController
                              .selectedPICClient[index]
                              .copyWith(position: value);
                        },
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.text_1,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text_4),
                          hintText: "Position",
                          errorStyle: GoogleFonts.plusJakartaSans(
                              color: AppColors.danger,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Contact",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_3,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: clientPic.contacts.length,
                        itemBuilder: (context, index) {
                          var contact = clientPic.contacts[index];

                          TextEditingController info = TextEditingController();
                          info.text = contact?.info ?? "Tidak ada";
                          TextEditingController note = TextEditingController();
                          note.text = contact?.note ?? "Tidak ada note";

                          return clientPic.contacts.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Contact ${index + 1}",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_3,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SelectFieldEditQuotation(
                                      name: "Type",
                                      child: Container(
                                        child: contact?.type == null
                                            ? Text(
                                                "Tidak ada tipe",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: AppColors.text_3,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            : Text(
                                                "${contact!.type}",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: AppColors.text_1,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                      ),
                                      onPressed: () {},
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Contact Info",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_2,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: info,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        color: AppColors.text_1,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        hintStyle: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.text_4),
                                        hintText: "Select Contact Type",
                                        errorStyle: GoogleFonts.plusJakartaSans(
                                            color: AppColors.danger,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SelectFieldEditQuotation(
                                      name: "Status",
                                      child: Container(
                                        child: contact?.status == null
                                            ? Text(
                                                "Tidak ada status",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: AppColors.text_3,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            : Text(
                                                "${contact!.status}",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: AppColors.text_1,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                      ),
                                      onPressed: () {},
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SelectFieldEditQuotation(
                                      name: "Detail Status",
                                      child: Container(
                                        child: contact?.detail == null
                                            ? Text(
                                                "Tidak ada detail status",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: AppColors.text_3,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            : Text(
                                                "${contact!.detail}",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color: AppColors.text_1,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                      ),
                                      onPressed: () {},
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Note",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_2,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: note,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        color: AppColors.text_1,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        hintStyle: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.text_4),
                                        hintText: "Note",
                                        errorStyle: GoogleFonts.plusJakartaSans(
                                            color: AppColors.danger,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      height: 51,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          clientPicController.selectedPICClient[index].contacts.remove(contact);
                                          clientPicController.selectedPICClient.refresh();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              const WidgetStatePropertyAll(
                                                  AppColors.bgDanger),
                                          foregroundColor:
                                              const WidgetStatePropertyAll(
                                                  AppColors.danger),
                                          overlayColor:
                                              const WidgetStatePropertyAll(
                                                  Colors.black12),
                                                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                                          shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Ionicons.trash_outline, size: 20,),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Delete Contact ${index + 1}",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              : Container();
                        },
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                        height: 51,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.addContactClientPIC,
                              arguments: {
                                "clientPic": clientPicController.selectedPICClient[index]
                              },
                            )?.then(
                              (value) {
                                clientPicController.selectedPICClient[index].contacts
                                    .add(value);
                                clientPicController.selectedPICClient.refresh();
                              },
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll(AppColors.primary),
                            foregroundColor:
                                const WidgetStatePropertyAll(AppColors.white_1),
                            overlayColor:
                                const WidgetStatePropertyAll(Colors.white30),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Ionicons.add_outline),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Add Contact",
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      (clientPicController.selectedPICClient.length > 0 &&
                              clientPicController.selectedPICClient.length != index + 1)
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 51,
            child: ElevatedButton(
                onPressed: () {
                  clientPicController.addPICClient();
                },
                style: ButtonStyle(
                  backgroundColor:
                      const WidgetStatePropertyAll(AppColors.white_1),
                  foregroundColor:
                      const WidgetStatePropertyAll(AppColors.primary),
                  overlayColor: const WidgetStatePropertyAll(Colors.white30),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      side:
                          const BorderSide(color: AppColors.primary, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Ionicons.add_outline),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add More",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
