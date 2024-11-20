import 'dart:io';

import 'package:cmlabs_connect/src/controllers/history_changes_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controller.dart';
import 'package:cmlabs_connect/src/models/history_changes_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/color.dart';
import '../../widgets/tag_button.dart';
import 'edit_quotation_view.dart';

class EditHistoryView extends StatelessWidget {
  EditHistoryView({super.key, required this.historyData});

  final HistoryChangesModel historyData;
  final HistoryChangesController historyChangesController =
      Get.put(HistoryChangesController());

  final UserController userController = Get.put(UserController());

  TextEditingController nameControllers = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController createdAtController = TextEditingController();
  TextEditingController fileController = TextEditingController();

  var isAvailableToUser = false.obs;

  var typeHistory = Rx<List<String?>>([]);
  var selectedFile = Rx<File?>(null);

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller) async {
    // Show date picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Show time picker
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine date and time into a single DateTime object
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format the DateTime to the desired string format
        final formattedDateTime =
            "${combinedDateTime.day.toString().padLeft(2, '0')}/"
            "${combinedDateTime.month.toString().padLeft(2, '0')}/"
            "${combinedDateTime.year} "
            "${pickedTime.format(context)}";

        controller.text = formattedDateTime;
      }
    }
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;
        selectedFile.value = File(file.path!);
        fileController.text = "${file.name}.${file.extension ?? ''}";
      } else {
        print("File selection canceled");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    historyChangesController.fetchTypeHistory(historyData.id);

    nameControllers.text = historyData.name;
    typeHistory.value = historyData.type;
    noteController.text = historyData.note ?? "";
    createdAtController.text = historyData.createdAtLabel;
    isAvailableToUser.value =
        historyData.availableToUser.contains(userController.user.value?.id);

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Edit History",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Project Activity",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.text_1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    "Activity Name",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.text_2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "*",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.danger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: nameControllers,
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
                  hintText: "Activity Name",
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
                name: "Type",
                child: Obx(
                  () {
                    if (typeHistory.value.isEmpty) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select type",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.text_3,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: typeHistory.value.length,
                        itemBuilder: (context, index) {
                          final type = typeHistory.value[index];
                          print("data type : $type");
                          return Row(
                            children: [
                              TagButton(
                                statusLabel: type ?? '',
                                onPressed: () {
                                  typeHistory.value.remove(type);
                                  typeHistory.refresh();
                                },
                              ),
                              (type?.length == index)
                                  ? SizedBox(
                                      width: 50,
                                    )
                                  : SizedBox()
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                onPressed: () {
                  Get.toNamed(
                    "/editSelect",
                    arguments: {
                      'selectData': "type_history",
                      'controller': historyChangesController,
                    },
                  )?.then(
                    (value) {
                      typeHistory.value = value;
                      typeHistory.refresh();
                    },
                  );
                },
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
                controller: noteController,
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Available to User",
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, color: AppColors.text_1),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Obx(
                    () {
                      return SizedBox(
                        height: 35,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            thumbColor:
                                WidgetStatePropertyAll(AppColors.white_1),
                            trackOutlineWidth: WidgetStatePropertyAll(0),
                            trackOutlineColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            trackColor: (!isAvailableToUser.value)
                                ? WidgetStatePropertyAll(Color(0xFFD8DAE5))
                                : WidgetStatePropertyAll(AppColors.primary),
                            value: isAvailableToUser.value,
                            onChanged: (bool value) {
                              isAvailableToUser.value = value;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Created at",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.text_2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: createdAtController,
                    readOnly: true,
                    cursorColor: AppColors.primary,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.text_1,
                    ),
                    decoration: InputDecoration(
                        hintText: "Select date",
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_4,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.text_1,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorStyle: GoogleFonts.plusJakartaSans(
                          color: AppColors.danger,
                          fontSize: 11,
                        ),
                        suffixIcon: Icon(
                          Ionicons.calendar_outline,
                          color: AppColors.text_1,
                        )),
                    onTap: () => _selectDateTime(context, createdAtController),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload File",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.text_2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectFile(),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: fileController,
                        readOnly: true,
                        cursorColor: Colors.blue,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Select file",
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.text_1,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          errorStyle: GoogleFonts.plusJakartaSans(
                            color: Colors.red,
                            fontSize: 11,
                          ),
                          suffixIcon: Icon(
                            Icons.attach_file,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    historyChangesController.nameActivity.value = nameControllers.text;
                    historyChangesController.status.value = historyData.status;
                    historyChangesController.type.value = typeHistory.value;
                    historyChangesController.note.value = noteController.text;
                    historyChangesController.availableToUser.value = isAvailableToUser.value ? "on" : "off";
                    historyChangesController.createdAt.value = createdAtController.text;
                    historyChangesController.file.value = selectedFile.value;
                    
                    historyChangesController.updateHistory(historyData.id);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor:
                        const WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: const WidgetStatePropertyAll(Colors.white30),
                    shadowColor: WidgetStatePropertyAll(Colors.transparent),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
