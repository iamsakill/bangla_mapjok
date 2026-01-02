import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../converters/area.dart';
import '../converters/length.dart';
import '../converters/volume.dart';
import '../converters/weight.dart';
import '../provider/locale_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../utils/localization.dart';
import 'language_selection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selected = 0;

  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLanguage());
    _loadBannerAd();
  }

  void _checkLanguage() {
    final locale = Provider.of<LocaleProvider>(context, listen: false);
    if (!locale.hasChosen) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
      );
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1125345878565611/9139675106', // TEST banner
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  void _onTabTapped(int index) {
    if (_selected != index) {
      HapticFeedback.lightImpact();
      setState(() => _selected = index);
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localeCode = localeProvider.locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    final List<Widget> pages = [
      AreaConverter(localeCode: localeCode),
      LengthConverter(localeCode: localeCode),
      VolumeConverter(localeCode: localeCode),
      WeightConverter(localeCode: localeCode),
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

    final List<String> labels = [
      S.t('area', localeCode),
      S.t('length', localeCode),
      S.t('volume', localeCode),
      S.t('weight', localeCode),
    ];

    return Scaffold(
      appBar: CustomAppBar(localeCode: localeProvider.locale.languageCode),
      drawer: const AppDrawer(),

      body: Column(
        children: [
          // MAIN CONTENT
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey<int>(_selected),
                child: pages[_selected],
              ),
            ),
          ),

          // BANNER AD (ABOVE BOTTOM NAV)
          if (_isBannerLoaded && _bannerAd != null)
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              alignment: Alignment.center,
              child: AdWidget(ad: _bannerAd!),
            ),
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
            currentIndex: _selected,
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
              4,
              (index) => BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(_selected == index ? 8 : 6),
                  decoration: BoxDecoration(
                    gradient: _selected == index
                        ? LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.15),
                              colorScheme.secondary.withOpacity(0.1),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _selected == index ? activeIcons[index] : icons[index],
                    size: _selected == index ? 26 : 24,
                  ),
                ),
                label: labels[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
