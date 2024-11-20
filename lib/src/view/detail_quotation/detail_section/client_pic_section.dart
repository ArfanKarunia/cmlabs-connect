import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../controllers/detail_quotation_controller.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_buttom.dart';
import '../edit_quotation_view.dart';

class ClientSidePICSection extends StatelessWidget {
  const ClientSidePICSection({
    super.key,
    required this.controller,
  });

  final DetailQuotationController controller;

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
                itemCount: controller.selectedPICClient.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var clientPic = controller.selectedPICClient[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (controller.selectedPICClient.length > 1)
                                ? "PIC ${index + 1} Name"
                                : "PIC Name",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text_3,
                            ),
                          ),
                          (controller.selectedPICClient.length > 1)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: CustomButton(
                                    backgroundColor: Colors.transparent,
                                    onPressed: () {
                                      controller.removePICClient(index);
                                      controller.selectedPICClient.refresh();
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
                        controller: controller.nameControllers[index],
                        onChanged: (value) {
                          controller.selectedPICClient[index] = controller
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
                        controller: controller.positionControllers[index],
                        onChanged: (value) {
                          controller.selectedPICClient[index] = controller
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
                                    SelectField(
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
                                    SelectField(
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
                                    SelectField(
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
                                          controller.selectedPICClient[index].contacts.remove(contact);
                                          controller.selectedPICClient.refresh();
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
                                "clientPic": controller.selectedPICClient[index]
                              },
                            )?.then(
                              (value) {
                                controller.selectedPICClient[index].contacts
                                    .add(value);
                                controller.selectedPICClient.refresh();
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
                      (controller.selectedPICClient.length > 0 &&
                              controller.selectedPICClient.length != index + 1)
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
                  controller.addPICClient();
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
