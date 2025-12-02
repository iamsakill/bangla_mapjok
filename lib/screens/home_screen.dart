import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../converters/area.dart';
import '../converters/length.dart';
import '../converters/volume.dart';
import '../converters/weight.dart';
import '../provider/locale_provider.dart';
import '../screens/setting_page.dart';
import '../utils/localization.dart';
import 'language_selection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLanguage());
  }

  void _checkLanguage() {
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    if (!locale.hasChosen) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
      );
    }
  }

  /// Adaptive Professional AppBar
  AppBar buildProfessionalAppBar(BuildContext context, String localeCode) {
    final theme = Theme.of(context).brightness;
    final bool isDark = theme == Brightness.dark;

    // Gradient colors for light/dark theme
    final gradientColors = isDark
        ? [Colors.deepPurple.shade700, Colors.indigo.shade900]
        : [Colors.indigo.shade500, Colors.blue.shade400];

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 4,
      centerTitle: true,
      title: Text(
        S.t('app_title', localeCode),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
    );
  }

  /// Adaptive BottomNavigationBar with dynamic labels
  BottomNavigationBar buildAdaptiveBottomNavBar(String localeCode) {
    final theme = Theme.of(context).brightness;
    final bool isDark = theme == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: _selected,
      onTap: (v) => setState(() => _selected = v),
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      selectedItemColor: isDark ? Colors.tealAccent : Colors.indigo,
      unselectedItemColor: isDark ? Colors.white70 : Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.map_outlined),
          label: S.t('area', localeCode),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to LocaleProvider for dynamic language updates
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localeCode = localeProvider.locale.languageCode;

    // Pages with dynamic localeCode
    final List<Widget> pages = [
      AreaConverter(localeCode: localeCode),
      LengthConverter(localeCode: localeCode),
      VolumeConverter(localeCode: localeCode),
      WeightConverter(localeCode: localeCode),
      const SettingsPage(), // SettingsPage handles locale internally
    ];

    return Scaffold(
      appBar: buildProfessionalAppBar(context, localeCode),
      body: pages[_selected],
      bottomNavigationBar: buildAdaptiveBottomNavBar(localeCode),
    );
  }
}
