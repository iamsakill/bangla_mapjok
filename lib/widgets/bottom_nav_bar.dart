// lib/screens/home_nav_controller.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../converters/area.dart';
import '../converters/length.dart';
import '../converters/volume.dart';
import '../converters/weight.dart';
import '../screens/setting_page.dart';
import '../provider/locale_provider.dart';
import '../utils/localization.dart';

class HomeNavController extends StatefulWidget {
  const HomeNavController({super.key});

  @override
  State<HomeNavController> createState() => _HomeNavControllerState();
}

class _HomeNavControllerState extends State<HomeNavController> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localeCode = localeProvider.locale.languageCode;

    // Pages with dynamic locale
    final List<Widget> pages = [
      AreaConverter(localeCode: localeCode),
      LengthConverter(localeCode: localeCode),
      VolumeConverter(localeCode: localeCode),
      WeightConverter(localeCode: localeCode),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.t('app_title', localeCode)),
        centerTitle: true,
      ),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: S.t('area', localeCode), // ✅ Now dynamically translated
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.straighten),
            label: S.t('length', localeCode),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.water_drop),
            label: S.t('volume', localeCode),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.monitor_weight),
            label: S.t('weight', localeCode),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: S.t('settings', localeCode),
          ),
        ],
      ),
    );
  }
}
