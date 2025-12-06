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

  PreferredSizeWidget buildProfessionalAppBar(String localeCode) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset('assets/images/icon.png', height: 32),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.t('app_title', localeCode),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                'Professional Unit Converter',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildModernBottomNavBar(String localeCode) {
    return NavigationBar(
      selectedIndex: _selected,
      onDestinationSelected: (v) => setState(() => _selected = v),
      indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
      elevation: 5,
      height: 75,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.map_outlined),
          selectedIcon: const Icon(Icons.map),
          label: S.t('area', localeCode),
        ),
        NavigationDestination(
          icon: const Icon(Icons.straighten_outlined),
          selectedIcon: const Icon(Icons.straighten),
          label: S.t('length', localeCode),
        ),
        NavigationDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: S.t('volume', localeCode),
        ),
        NavigationDestination(
          icon: const Icon(Icons.monitor_weight_outlined),
          selectedIcon: const Icon(Icons.monitor_weight),
          label: S.t('weight', localeCode),
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: S.t('settings', localeCode),
        ),
      ],
    );
  }

  Widget buildHeaderSection(String localeCode) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to ${S.t('app_title', localeCode)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Quickly convert Area, Length, Volume, and Weight with ease. Select a category below to get started!',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: colorScheme.outline, thickness: 1),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localeCode = localeProvider.locale.languageCode;

    final List<Widget> pages = [
      AreaConverter(localeCode: localeCode),
      LengthConverter(localeCode: localeCode),
      VolumeConverter(localeCode: localeCode),
      WeightConverter(localeCode: localeCode),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: buildProfessionalAppBar(localeCode),
      body: Column(
        children: [
          // Add a header section before the converter content
          buildHeaderSection(localeCode),
          // Expanded page content
          Expanded(child: pages[_selected]),
        ],
      ),
      bottomNavigationBar: buildModernBottomNavBar(localeCode),
    );
  }
}
