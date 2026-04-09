import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_makita_verse_app/src/config/di.dart';

import 'src/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDI();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const AppWidget());
  });
}
