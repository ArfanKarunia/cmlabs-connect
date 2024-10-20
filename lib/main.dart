import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quotation_app/src/app.dart';
import 'package:quotation_app/src/models/client_pic_model.dart';
import 'package:quotation_app/src/models/dashboard_data_model.dart';
import 'package:quotation_app/src/models/quotation_model.dart';
import 'package:quotation_app/src/models/user_model.dart';
import 'package:quotation_app/src/utils/custom_http_overrides.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  // initialization HIVE
  await Hive.initFlutter();

  // Daftarkan adapter untuk setiap model
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(QuotationAdapter());
  Hive.registerAdapter(DashboardDataAdapter());
  
  // Hive.registerAdapter(CategoryAdapter());
  // Hive.registerAdapter(ClientSourceAdapter());

  // membuka box (tempat penyimpanan) untuk Quotation
  await Hive.openBox<Quotation>('quotationBox');
  await Hive.openBox<ClientPic>('picBox');
  await Hive.openBox<User>('userBox');
  await Hive.openBox<DashboardData>('dashboardBox');

  
  HttpOverrides.global = CustomHttpOverrides();
  // await dotenv.load(fileName: ".env");

  await SentryFlutter.init((options) {
    // add the sentry proeject link
    options.dsn = 'https://examplePublicKey@o0.ingest.sentry.io/0';

    // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
    // We recommend adjusting this value in production.

    options.tracesSampleRate = 1.0;
    options.profilesSampleRate = 1.0;
  }, appRunner: () => runApp(const MyApp()));
}
