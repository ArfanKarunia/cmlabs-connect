import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/account/account_controller.dart';
import '../../../utils/color.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';

class FormPublicationView extends StatefulWidget {
  final String status;
  final int? id;
  const FormPublicationView({super.key, required this.status, this.id});

  @override
  State<FormPublicationView> createState() => _FormPublicationViewState();
}

class _FormPublicationViewState extends State<FormPublicationView> {
  final AccountController controller = Get.find<AccountController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  DateTime? publicationDate;
  final TextEditingController descriptionController = TextEditingController();

  String? titleError;
  String? urlError;
  String? dateError;

  bool validateForm() {
    titleError = titleController.text.isEmpty
        ? "The 'Publication Title' field is required"
        : titleController.text.length > 64
            ? "The maximum character of 'Publication Title' is 64 characters"
            : null;
    urlError = urlController.text.isEmpty ? "The 'Publication Link' field is required" : null;
    dateError = publicationDate == null ? "The 'Date' field is required" : null;
    setState(() {});

    return titleError == null && urlError == null && dateError == null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.status == 'edit') {
      try {
        final publication = controller.publicationList.firstWhere(
          (exp) => exp!.id == widget.id,
          orElse: () => null,
        );

        if (publication != null) {
          titleController.text = publication.title;
          urlController.text = publication.url;
          descriptionController.text = publication.description ?? "";
          publicationDate = publication.year;
        }
      } catch (e) {
        debugPrint('Error fetching publication: $e');
      }
    } else {
      controller.clearPublication();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    urlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Publication", titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(
            "Publication",
            style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
          ),

          const SizedBox(height: 14),

          // Publication Title
          InboxAddField(
            title: 'Publication Title',
            isRequired: true,
            child: CustomFormField(
              controller: titleController,
              errorText: titleError,
              hintText: 'Publication Title',
            ),
          ),

          const SizedBox(height: 12),

          // Publication Link
          InboxAddField(
            title: 'Publication Link',
            isRequired: true,
            child: CustomFormField(
              controller: urlController,
              errorText: urlError,
              hintText: 'Publication Link',
            ),
          ),

          const SizedBox(height: 12),

          // Date
          InboxAddField(
            title: 'Date',
            isRequired: true,
            child: CustomSelectField(
              errorText: dateError,
              child: InboxTextOnField(
                title: 'Select Date',
                selected: publicationDate != null
                    ? {
                        'label': formatDate(publicationDate),
                        'value': formatDate(publicationDate),
                      }
                    : null,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) setState(() => publicationDate = pickedDate);
              },
            ),
          ),

          const SizedBox(height: 12),

          // Description
          InboxAddField(
            title: 'Description',
            child: CustomFormField(
              controller: descriptionController,
              hintText: 'Description',
            ),
          ),

          const SizedBox(height: 14),

          Obx(
            () => controller.isLoadingPublication.value
                ? const CustomLoadingButton()
                : CustomSubmitButton(
                    title: 'Save',
                    onTap: () {
                      if (validateForm()) {
                        controller.publicationTitle.value = titleController.text;
                        controller.publicationUrl.value = urlController.text;
                        controller.publicationYear.value =
                            "${publicationDate?.year}-${publicationDate?.month}-${publicationDate?.day}";
                        controller.publicationDescription.value = descriptionController.text;

                        if (widget.status == "add") {
                          controller.addPublication();
                        } else if (widget.status == "edit") {
                          controller.updatePublication(widget.id!);
                        }
                      }
                    },
                  ),
          ),

          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
