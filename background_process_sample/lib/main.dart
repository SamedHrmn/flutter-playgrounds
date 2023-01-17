import 'package:flutter/material.dart';

import 'util/background_service_helper.dart';
import 'util/shared_prefs_util.dart';
import 'view/counter_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsUtil().init();
  await BackgroundServiceHelper.initializeService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}
