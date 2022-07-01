import 'package:flutter/material.dart';

import 'components/menu_bar.dart';
// import 'myapp.dart';
import 'package:get/get.dart';

import 'controller/getx_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  static final ThemeGetx cTheme = Get.put(ThemeGetx());

  @override
  Widget build(BuildContext context) {
    return Obx(() => MaterialApp(
      theme: cTheme.themeObx.value,
      debugShowCheckedModeBanner: false,
      title: _title,
      home: const MenuBar(index: 0),
    ));
  }
}
