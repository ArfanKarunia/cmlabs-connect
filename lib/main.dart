import 'package:flutter/material.dart';
import 'package:quotation_app/src/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options){
      // add the sentry proeject link
      options.dsn = 'https://examplePublicKey@o0.ingest.sentry.io/0';

      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.

      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp())
  );
}