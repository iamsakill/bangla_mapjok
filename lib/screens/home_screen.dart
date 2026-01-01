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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selected = 0;
  late AnimationController _headerController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _headerController.forward();
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLanguage());
  }

  @override
  void dispose() {
    _headerController.dispose();
    _fadeController.dispose();
    super.dispose();
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
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Row(
          children: [
            Hero(
              tag: 'app_icon',
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primaryContainer,
                            colorScheme.secondaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.asset('assets/images/icon.png', height: 32),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ).createShader(bounds),
                  child: Text(
                    S.t('app_title', localeCode),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Professional Unit Converter',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModernBottomNavBar(String localeCode) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _selected,
        onDestinationSelected: (v) {
          setState(() => _selected = v);
          // Restart page transition animation
          _fadeController.reset();
          _fadeController.forward();
        },
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
        elevation: 0,
        height: 75,
        animationDuration: const Duration(milliseconds: 400),
        destinations: [
          _buildAnimatedDestination(
            icon: Icons.map_outlined,
            selectedIcon: Icons.map,
            label: S.t('area', localeCode),
            index: 0,
          ),
          _buildAnimatedDestination(
            icon: Icons.straighten_outlined,
            selectedIcon: Icons.straighten,
            label: S.t('length', localeCode),
            index: 1,
          ),
          _buildAnimatedDestination(
            icon: Icons.water_drop_outlined,
            selectedIcon: Icons.water_drop,
            label: S.t('volume', localeCode),
            index: 2,
          ),
          _buildAnimatedDestination(
            icon: Icons.monitor_weight_outlined,
            selectedIcon: Icons.monitor_weight,
            label: S.t('weight', localeCode),
            index: 3,
          ),
          _buildAnimatedDestination(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: S.t('settings', localeCode),
            index: 4,
          ),
        ],
      ),
    );
  }

  NavigationDestination _buildAnimatedDestination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selected == index;
    return NavigationDestination(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Icon(
          isSelected ? selectedIcon : icon,
          key: ValueKey(isSelected),
        ),
      ),
      label: label,
    );
  }

  Widget _buildQuickStat(String value, String label, ColorScheme colorScheme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
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
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: pages[_selected],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildModernBottomNavBar(localeCode),
    );
  }
}
