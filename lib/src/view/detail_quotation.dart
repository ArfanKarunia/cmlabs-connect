import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/controllers/url_controller.dart';
import 'package:quotation_app/src/models/quotation_model.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailQuotation extends StatelessWidget {
  DetailQuotation({super.key, required this.quotation});

  final Quotation quotation;

  final UrlController urlController = Get.put(UrlController());

  final String webUrl =
      'https://wa.me/6281250861354?text=Halo%20Gaiss,%20welkom%20bek%20tu%20mai%20ceneell';

  @override
  Widget build(BuildContext context) {
    // Mendapatkan waktu saat ini
    DateTime now = DateTime.now();

    // Mendapatkan waktu `joinedAt` dari quotation
    DateTime joinedAt = quotation.joinedAt;

    // Menghitung selisih antara waktu sekarang dan `joinedAt`
    Duration difference = now.difference(joinedAt);

    // Mendapatkan jumlah hari dari selisih
    int pitchingDuration = difference.inDays;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Quotation Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          quotation.companyName!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          '#${quotation.id.toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: AppColors.white,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status Quotation
                              const Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                quotation.status,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // Joined at
                              const Text(
                                "Joined at",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "${quotation.joinedAt}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // name
                              const Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                quotation.name ?? '-',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // email
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                quotation.email ?? '-',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // Whatsapp Number
                              const Text(
                                "Whatsapp Number",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${quotation.whatsappNumber}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      urlController.launchUrl(webUrl);
                                    },
                                    icon: const Icon(
                                      Ionicons.logo_whatsapp,
                                      size: 15,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),

                        // Vertical Divider
                        SizedBox(
                          height: 150,
                          child: const VerticalDivider(
                            color: Colors.white54,
                            thickness: 2,
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status Quotation
                              const Text(
                                "Company Website",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "${quotation.companyWebsite}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // Joined at
                              const Text(
                                "Registration Status",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              const Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // name
                              const Text(
                                "Company Profile/Proposal",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              const Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // email
                              const Text(
                                "Region",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "${quotation.region}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // Whatsapp Number
                              const Text(
                                "Client Source",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "${quotation.clientSource}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    // email
                    const Text(
                      "Page Source",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      "${quotation.pageSource}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.lightBlue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // email
                          const Text(
                            "Pitching Duration",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryText,
                            ),
                          ),
                          Text(
                            "$pitchingDuration days",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: (now.isAfter(joinedAt))
                                  ? AppColors.green
                                  : AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Category",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: quotation.category!.length,
                  itemBuilder: (context, index) {
                    final category = quotation.category![index];

                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        category.name,
                        style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PIC",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: 10,
                      // ),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xff9C9C9C),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Priority",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                // padding: EdgeInsets.symmetric(
                                //   horizontal: 10,
                                // ),
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff9C9C9C),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                // padding: EdgeInsets.symmetric(
                                //   horizontal: 10,
                                // ),
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff9C9C9C),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Tyoe",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: 10,
                      // ),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xff9C9C9C),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          // fixedSize: WidgetStatePropertyAll(Size.fromWidth(double.infinity/2)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor:
                              const WidgetStatePropertyAll(AppColors.white),
                          foregroundColor:
                              const WidgetStatePropertyAll(AppColors.primary),
                        ),
                        onPressed: () {},
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
