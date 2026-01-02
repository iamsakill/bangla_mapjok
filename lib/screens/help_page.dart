import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/locale_provider.dart';
import '../utils/localization.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int? expandedIndex;

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
          isBangla ? 'সাহায্য' : 'Help',
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
            // Header Card
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildHeaderCard(colorScheme, isBangla),
            ),

            const SizedBox(height: 24),

            // Quick Start Guide
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildQuickStartCard(colorScheme, isBangla),
            ),

            const SizedBox(height: 16),

            // FAQ Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildFAQSection(colorScheme, isBangla),
            ),

            const SizedBox(height: 16),

            // Contact Support Card
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildContactCard(colorScheme, isBangla),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ColorScheme colorScheme, bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(24),
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.help_outline,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isBangla ? 'আমরা সাহায্য করতে এখানে আছি' : 'We\'re Here to Help',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isBangla
                ? 'সাধারণ প্রশ্ন এবং গাইড দেখুন'
                : 'Browse common questions and guides',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartCard(ColorScheme colorScheme, bool isBangla) {
    final steps = isBangla
        ? [
            {
              'icon': Icons.input,
              'title': 'মান লিখুন',
              'desc': 'আপনার সংখ্যা ইনপুট করুন',
            },
            {
              'icon': Icons.category,
              'title': 'ইউনিট নির্বাচন করুন',
              'desc': 'From এবং To ইউনিট বেছে নিন',
            },
            {
              'icon': Icons.autorenew,
              'title': 'স্বয়ংক্রিয় রূপান্তর',
              'desc': 'তাৎক্ষণিক ফলাফল পান',
            },
          ]
        : [
            {
              'icon': Icons.input,
              'title': 'Enter Value',
              'desc': 'Input your number',
            },
            {
              'icon': Icons.category,
              'title': 'Select Units',
              'desc': 'Choose From and To units',
            },
            {
              'icon': Icons.autorenew,
              'title': 'Auto Convert',
              'desc': 'Get instant results',
            },
          ];

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
                  Icons.rocket_launch,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isBangla ? 'দ্রুত শুরু করুন' : 'Quick Start',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              step['icon'] as IconData,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                step['title'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step['desc'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFAQSection(ColorScheme colorScheme, bool isBangla) {
    final faqs = isBangla
        ? [
            {
              'question': 'কিভাবে ইউনিট রূপান্তর করব?',
              'answer':
                  'মান ইনপুট করুন, From এবং To ইউনিট নির্বাচন করুন। ফলাফল স্বয়ংক্রিয়ভাবে দেখানো হবে।',
            },
            {
              'question': 'কোন ইউনিট সমর্থিত?',
              'answer':
                  'এরিয়া, দূরত্ব, ওজন, তাপমাত্রা এবং আরও অনেক ইউনিট সমর্থিত।',
            },
            {
              'question': 'ভাষা কীভাবে পরিবর্তন করব?',
              'answer': 'সেটিংস পেজে যান এবং আপনার পছন্দের ভাষা নির্বাচন করুন।',
            },
            {
              'question': 'রূপান্তর কতটা নির্ভুল?',
              'answer':
                  'আমরা উচ্চ নির্ভুলতার সাথে 6 দশমিক স্থান পর্যন্ত ফলাফল প্রদান করি।',
            },
          ]
        : [
            {
              'question': 'How do I convert units?',
              'answer':
                  'Enter a value, select From and To units. Results appear automatically.',
            },
            {
              'question': 'Which units are supported?',
              'answer':
                  'Area, distance, weight, temperature, and many more units are supported.',
            },
            {
              'question': 'How to change language?',
              'answer':
                  'Go to Settings page and select your preferred language.',
            },
            {
              'question': 'How accurate are conversions?',
              'answer':
                  'We provide high precision results up to 6 decimal places.',
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
                child: Icon(Icons.quiz, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                isBangla ? 'সাধারণ প্রশ্ন' : 'FAQ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final faq = entry.value;
            final isExpanded = expandedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      expandedIndex = isExpanded ? null : index;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? colorScheme.primaryContainer.withOpacity(0.3)
                          : colorScheme.surfaceContainerHighest.withOpacity(
                              0.3,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isExpanded
                            ? colorScheme.primary.withOpacity(0.3)
                            : colorScheme.outline.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.help_outline,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                faq['question'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: colorScheme.primary,
                            ),
                          ],
                        ),
                        if (isExpanded) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              faq['answer'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContactCard(ColorScheme colorScheme, bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.secondaryContainer.withOpacity(0.3),
            colorScheme.tertiaryContainer.withOpacity(0.2),
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
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent,
              color: colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isBangla ? 'আরও সাহায্য প্রয়োজন?' : 'Need More Help?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isBangla
                ? 'আমাদের সাপোর্ট টিমের সাথে যোগাযোগ করুন'
                : 'Contact our support team',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                // Add email or contact functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBangla
                          ? 'সাপোর্ট ইমেইল: support@example.com'
                          : 'Support Email: support@example.com',
                    ),
                    backgroundColor: colorScheme.primary,
                  ),
                );
              },
              icon: const Icon(Icons.email_outlined, size: 20),
              label: Text(
                isBangla ? 'যোগাযোগ করুন' : 'Contact Us',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
