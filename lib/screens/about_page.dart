import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/locale_provider.dart';
import '../utils/localization.dart';

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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isBangla ? 'সম্পর্কে' : 'About',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
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

            // Version Info
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildVersionInfo(colorScheme, isBangla),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(ColorScheme colorScheme, bool isBangla) {
    return Container(
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
            child: const Icon(
              Icons.calculate_outlined,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.t('app_title', isBangla ? 'bn' : 'en'),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isBangla ? 'বর্ণনা' : 'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isBangla
                ? 'এটি একটি আধুনিক এবং শক্তিশালী ইউনিট কনভার্টার অ্যাপ্লিকেশন যা বিভিন্ন ধরনের পরিমাপ একক রূপান্তরের জন্য ডিজাইন করা হয়েছে। এই অ্যাপটি দ্রুত, নির্ভুল এবং ব্যবহার করা সহজ।'
                : 'A modern and powerful unit converter application designed for various types of measurement conversions. This app is fast, accurate, and easy to use.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
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
              'icon': Icons.category,
              'title': 'একাধিক বিভাগ',
              'desc': 'বিভিন্ন ইউনিট সমর্থন',
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
              'icon': Icons.category,
              'title': 'Multiple Categories',
              'desc': 'Various units supported',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.stars, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                isBangla ? 'বৈশিষ্ট্য' : 'Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primaryContainer.withOpacity(0.5),
                          colorScheme.secondaryContainer.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          feature['desc'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
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

  Widget _buildDeveloperCard(ColorScheme colorScheme, bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.code, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                isBangla ? 'মো: শাকিল আহমেদ' : 'Md Shakil Ahamed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isBangla
                ? 'তৈরি করেছেন ভালোবাসা এবং যত্নের সাথে'
                : 'Made with love and care',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '© 2026 ${S.t('app_title', isBangla ? 'bn' : 'en')}',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(ColorScheme colorScheme, bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.2),
            colorScheme.secondaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 16, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            isBangla ? 'সংস্করণ ১.০.০ (বিল্ড ১)' : 'Version 1.0.0 (Build 1)',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
