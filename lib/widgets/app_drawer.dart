import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../screens/setting_page.dart';
import '../screens/about_page.dart';
import '../screens/help_page.dart';
import '../provider/locale_provider.dart';
import '../services/auth_service.dart';
import '../utils/localization.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late List<AnimationController> _symbolControllers;
  late List<Animation<Offset>> _symbolAnimations;

  final List<String> _symbols = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '+',
    '−',
    '×',
    '÷',
    '=',
    '%',
    '√',
    'π',
    '∑',
    '∞',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();

    // Setup symbol animations
    _setupSymbolAnimations();
  }

  void _setupSymbolAnimations() {
    _symbolControllers = List.generate(
      _symbols.length,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 3000 + (index * 100)),
      )..repeat(),
    );

    _symbolAnimations = _symbolControllers.asMap().entries.map((entry) {
      final index = entry.key;
      final controller = entry.value;

      // Create different movement patterns
      final startX = (index % 4) * 0.3 - 0.2;
      final endX = startX + (index.isEven ? 0.3 : -0.3);
      final startY = -0.3 - (index * 0.1);
      final endY = 1.2 + (index * 0.05);

      return Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset(endX, endY),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    }).toList();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (var controller in _symbolControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final auth = Provider.of<AuthService>(context);
    final isBangla = localeProvider.isBangla;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Enhanced Drawer Header with Animated Background
                    _buildDrawerHeader(colorScheme, localeProvider),

                    const SizedBox(height: 8),

                    // Animated Menu Items
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              _buildDrawerItem(
                                context,
                                icon: Icons.settings_outlined,
                                title: isBangla ? 'সেটিংস' : 'Settings',
                                subtitle: isBangla
                                    ? 'অ্যাপ কাস্টমাইজ করুন'
                                    : 'Customize your app',
                                colorScheme: colorScheme,
                                onTap: () => _navigateToSettings(context),
                              ),
                              const SizedBox(height: 8),
                              _buildDrawerItem(
                                context,
                                icon: Icons.info_outline,
                                title: isBangla ? 'সম্পর্কে' : 'About',
                                subtitle: isBangla
                                    ? 'অ্যাপ সম্পর্কে জানুন'
                                    : 'Learn about the app',
                                colorScheme: colorScheme,
                                onTap: () => _navigateToAbout(context),
                              ),
                              const SizedBox(height: 8),
                              _buildDrawerItem(
                                context,
                                icon: Icons.help_outline,
                                title: isBangla ? 'সাহায্য' : 'Help',
                                subtitle: isBangla
                                    ? 'সহায়তা পান'
                                    : 'Get assistance',
                                colorScheme: colorScheme,
                                onTap: () => _navigateToHelp(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Divider with style
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(
                        color: colorScheme.outline.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // App Version
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              size: 16,
                              color: colorScheme.onSurfaceVariant.withOpacity(
                                0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isBangla ? 'সংস্করণ ১.০.০' : 'Version 1.0.0',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant.withOpacity(
                                  0.5,
                                ),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerHeader(
    ColorScheme colorScheme,
    LocaleProvider localeProvider,
  ) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.errorContainer.withOpacity(0.8),
            colorScheme.secondary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated symbols background
          ClipRect(
            child: Stack(
              children: _symbolAnimations.asMap().entries.map((entry) {
                final index = entry.key;
                final animation = entry.value;

                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Positioned(
                      left:
                          MediaQuery.of(context).size.width *
                          0.85 *
                          animation.value.dx,
                      top: 220 * animation.value.dy,
                      child: Opacity(
                        opacity: 0.12,
                        child: Transform.rotate(
                          angle: _symbolControllers[index].value * 2 * math.pi,
                          child: Text(
                            _symbols[index],
                            style: TextStyle(
                              fontSize: 28 + (index % 3) * 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          // Content overlay
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Hero(
                    tag: 'app_icon',
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.8),
                            colorScheme.secondary.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/icon.png',
                        height: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      S.t('app_title', localeProvider.locale.languageCode),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      localeProvider.isBangla
                          ? 'দ্রুত এবং নির্ভুল রূপান্তর'
                          : 'Fast and accurate conversions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.3,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primaryContainer.withOpacity(0.5),
                        colorScheme.secondaryContainer.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: colorScheme.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
  }

  void _navigateToAbout(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AboutPage()));
  }

  void _navigateToHelp(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const HelpPage()));
  }
}
