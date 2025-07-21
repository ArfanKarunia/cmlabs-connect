import 'package:cmlabs_connect/src/widgets/inbox/inbox_add_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/inbox/quotation/add_quotation_controller.dart';
import '../../../utils/color.dart';
import '../../../utils/toast.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';

class QuotationAddSelectNewView extends StatefulWidget {
  final String title;
  final String data;
  final int maxDigit;
  const QuotationAddSelectNewView({super.key, required this.title, required this.data, required this.maxDigit});

  @override
  State<QuotationAddSelectNewView> createState() => _QuotationAddSelectNewViewState();
}

class _QuotationAddSelectNewViewState extends State<QuotationAddSelectNewView> {
  final controller = Get.find<AddQuotationController>();

  late final List<Map<String, String>> choice;
  final TextEditingController fieldController = TextEditingController();
  String? fieldError;
  bool isFormValid = false;

  void _validateForm() {
    if (fieldController.text.isEmpty) {
      fieldError = "The ${widget.title} must not be empty.";
    } else if (choice.any((map) => map['label'] == fieldController.text)) {
      fieldError = "'${fieldController.text}' already exists in the database!";
    } else if (fieldController.text.length > widget.maxDigit) {
      fieldError = "The ${widget.title} character is too long! maximum ${widget.maxDigit} characters.";
    } else {
      fieldError = null;
    }

    setState(() => isFormValid = fieldError == null);
  }

  @override
  void initState() {
    super.initState();
    choice = controller.getList(widget.data);
    fieldController.addListener(_validateForm);
  }

  @override
  void dispose() {
    fieldController.removeListener(_validateForm);
    fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Add ${widget.title}'),
      backgroundColor: AppColors.scaffoldBgColor2,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            InboxAddField(
              title: widget.title,
              child: CustomFormField(
                controller: fieldController,
                errorText: fieldError,
              ),
            ),
            const SizedBox(height: 20),
            CustomSubmitButton(
              title: 'Save',
              isDisabled: !isFormValid,
              onTap: () {
                controller.addValue(
                  data: widget.data,
                  value: fieldController.text,
                );
                showSuccessToast('Berhasil menambahkan ${widget.title}: ${fieldController.text}');
                Get.back();
              },
            )
          ],
        ),
      ),
    );
  }
}
