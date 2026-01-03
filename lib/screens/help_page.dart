import 'package:bangla_mapjok/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import this
import '../provider/locale_provider.dart';

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

  // Helper function to launch URLs safely
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
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
      appBar: CustomAppBar(
        localeCode: currentLocale,
        heroTag: 'help_app_icon', // ✅ unique hero tag for HelpPage
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildHeaderCard(colorScheme, isBangla),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildQuickStartCard(colorScheme, isBangla),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildFAQSection(colorScheme, isBangla),
            ),
            const SizedBox(height: 16),
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
      width: double.infinity,
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
            isBangla ? 'আমরা সাহায্য করতে এখানে আছি' : "We're Here to Help",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isBangla ? 'সাধারণ প্রশ্ন এবং গাইড দেখুন' : 'Browse guides',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartCard(ColorScheme colorScheme, bool isBangla) {
    final steps = isBangla
        ? [
            {'icon': Icons.input, 'title': 'মান লিখুন', 'desc': 'ইনপুট করুন'},
            {
              'icon': Icons.category,
              'title': 'ইউনিট নির্বাচন',
              'desc': 'বেছে নিন',
            },
            {'icon': Icons.autorenew, 'title': 'রূপান্তর', 'desc': 'ফলাফল পান'},
          ]
        : [
            {
              'icon': Icons.input,
              'title': 'Enter Value',
              'desc': 'Input number',
            },
            {
              'icon': Icons.category,
              'title': 'Select Units',
              'desc': 'Choose units',
            },
            {
              'icon': Icons.autorenew,
              'title': 'Convert',
              'desc': 'Get results',
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
          Row(
            children: [
              Icon(Icons.rocket_launch, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                isBangla ? 'দ্রুত শুরু করুন' : 'Quick Start',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          step['desc'] as String,
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
              'question': 'কিভাবে রূপান্তর করব?',
              'answer': 'মান ইনপুট করে ইউনিট নির্বাচন করুন।',
            },
            {
              'question': 'কোন ইউনিট সমর্থিত?',
              'answer': 'এরিয়া, দূরত্ব, ওজন ইত্যাদি।',
            },
            {'question': 'ভাষা পরিবর্তন?', 'answer': 'সেটিংস পেজে যান।'},
            {'question': 'নির্ভুলতা?', 'answer': '৬ দশমিক স্থান পর্যন্ত।'},
          ]
        : [
            {
              'question': 'How to convert?',
              'answer': 'Enter value and select units.',
            },
            {'question': 'Units supported?', 'answer': 'Area, weight, etc.'},
            {'question': 'Change language?', 'answer': 'Go to Settings.'},
            {'question': 'Accuracy?', 'answer': 'Up to 6 decimal places.'},
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
          Row(
            children: [
              Icon(Icons.quiz, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                isBangla ? 'সাধারণ প্রশ্ন' : 'FAQ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
              child: InkWell(
                onTap: () =>
                    setState(() => expandedIndex = isExpanded ? null : index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isExpanded
                        ? colorScheme.primaryContainer.withOpacity(0.2)
                        : colorScheme.surfaceContainerHighest.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq['question'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            size: 20,
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 12),
                        Text(
                          faq['answer'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
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
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.secondaryContainer.withOpacity(0.4),
            colorScheme.tertiaryContainer.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.support_agent, size: 40, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            isBangla ? 'আরও সাহায্য প্রয়োজন?' : 'Need More Help?',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                _showContactOptions(context, colorScheme, isBangla);
              },
              icon: const Icon(Icons.contact_support_outlined),
              label: Text(isBangla ? 'যোগাযোগ করুন' : 'Contact Us'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
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

  void _showContactOptions(
    BuildContext context,
    ColorScheme colorScheme,
    bool isBangla,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isBangla ? 'যোগাযোগের মাধ্যম' : 'Contact Options',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _contactTile(
              icon: Icons.chat_bubble_outline,
              title: 'WhatsApp',
              subtitle: 'Message on WhatsApp',
              color: Colors.green,
              onTap: () => _launchURL("https://wa.me/8801758454772"),
            ),
            _contactTile(
              icon: Icons.call_outlined,
              title: isBangla ? 'কল করুন' : 'Direct Call',
              subtitle: '+8801758454772',
              color: Colors.blue,
              onTap: () => _launchURL("tel:+8801758454772"),
            ),
            _contactTile(
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: 'md.shakilahamedxox72@gmail.com',
              color: Colors.redAccent,
              onTap: () => _launchURL("mailto:md.shakilahamedxox72@gmail.com"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
