import 'package:bangla_mapjok/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/locale_provider.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

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

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isBangla = localeProvider.isBangla;
    final colorScheme = Theme.of(context).colorScheme;
    final String currentLocale = isBangla ? 'bn' : 'en';

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(localeCode: currentLocale, heroTag: ''),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            // App Logo Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildLogoSection(colorScheme, isBangla),
              ),
            ),

            const SizedBox(height: 24),

            // Description Card
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildDescriptionCard(colorScheme, isBangla),
            ),

            const SizedBox(height: 16),

            // Features Card
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildFeaturesCard(colorScheme, isBangla),
            ),

            const SizedBox(height: 16),

            // Developer Info Card
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildDeveloperCard(colorScheme, isBangla),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(ColorScheme colorScheme, bool isBangla) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.8),
            colorScheme.secondary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Hero(
              // FIXED: Changed tag from 'app_icon' to 'app_icon_about'
              // to prevent duplicate tag error with the AppBar logo.
              tag: 'app_icon_about',
              child: Image.asset(
                'assets/images/icon.png',
                height: 42,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isBangla ? 'মাপজোক সম্পর্কে' : 'About Mapjok',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isBangla ? 'সংস্করণ ১.০.০' : 'Version 1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(ColorScheme colorScheme, bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                isBangla ? 'বর্ণনা' : 'Description',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isBangla
                ? 'এটি একটি আধুনিক এবং শক্তিশালী ইউনিট কনভার্টার অ্যাপ্লিকেশন যা বিভিন্ন ধরনের পরিমাপ একক রূপান্তরের জন্য ডিজাইন করা হয়েছে।'
                : 'A modern and powerful unit converter application designed for various types of measurement conversions.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard(ColorScheme colorScheme, bool isBangla) {
    final features = isBangla
        ? [
            {
              'icon': Icons.speed,
              'title': 'দ্রুত রূপান্তর',
              'desc': 'তাৎক্ষণিক ফলাফল',
            },
            {
              'icon': Icons.precision_manufacturing,
              'title': 'উচ্চ নির্ভুলতা',
              'desc': 'সঠিক গণনা',
            },
            {
              'icon': Icons.language,
              'title': 'বহুভাষিক',
              'desc': 'বাংলা ও ইংরেজি',
            },
          ]
        : [
            {
              'icon': Icons.speed,
              'title': 'Fast Conversion',
              'desc': 'Instant results',
            },
            {
              'icon': Icons.precision_manufacturing,
              'title': 'High Precision',
              'desc': 'Accurate calculations',
            },
            {
              'icon': Icons.language,
              'title': 'Multilingual',
              'desc': 'Bengali & English',
            },
          ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isBangla ? 'বৈশিষ্ট্য' : 'Features',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...features.map(
            (f) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(f['icon'] as IconData, color: colorScheme.primary),
              title: Text(
                f['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                f['desc'] as String,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard(ColorScheme colorScheme, bool isBangla) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            isBangla ? 'মো: শাকিল আহমেদ' : 'Md Shakil Ahamed',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            isBangla ? 'ডেভেলপার' : 'Developer',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
