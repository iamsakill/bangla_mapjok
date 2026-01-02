import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../converters/area.dart';
import '../converters/length.dart';
import '../converters/volume.dart';
import '../converters/weight.dart';
import '../provider/locale_provider.dart';
import '../utils/localization.dart';

class HomeNavController extends StatefulWidget {
  const HomeNavController({super.key});

  @override
  State<HomeNavController> createState() => _HomeNavControllerState();
}

class _HomeNavControllerState extends State<HomeNavController>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_index != index) {
      HapticFeedback.lightImpact();
      _controller.reset();
      setState(() => _index = index);
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localeCode = localeProvider.locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    // Labels (dynamic)
    final List<String> labels = [
      S.t('area', localeCode),
      S.t('length', localeCode),
      S.t('volume', localeCode),
      S.t('weight', localeCode),
    ];

    final List<IconData> icons = [
      Icons.map_outlined,
      Icons.straighten_outlined,
      Icons.water_drop_outlined,
      Icons.monitor_weight_outlined,
    ];

    final List<IconData> activeIcons = [
      Icons.map,
      Icons.straighten,
      Icons.water_drop,
      Icons.monitor_weight,
    ];

    return Scaffold(
      extendBody: true,

      /// Only the 4 converter pages
      body: IndexedStack(
        index: _index,
        children: [
          AreaConverter(localeCode: localeCode),
          LengthConverter(localeCode: localeCode),
          VolumeConverter(localeCode: localeCode),
          WeightConverter(localeCode: localeCode),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurfaceVariant.withOpacity(0.6),
            selectedFontSize: 12,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            items: List.generate(
              4, // Only 4 items now
              (index) => BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(_index == index ? 8 : 6),
                  decoration: BoxDecoration(
                    gradient: _index == index
                        ? LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.15),
                              colorScheme.secondary.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _index == index ? activeIcons[index] : icons[index],
                    size: _index == index ? 26 : 24,
                  ),
                ),
                label: labels[index],
                tooltip: labels[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
