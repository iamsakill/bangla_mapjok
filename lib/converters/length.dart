import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/localization.dart';

class LengthConverter extends StatefulWidget {
  final String localeCode;
  const LengthConverter({super.key, required this.localeCode});

  @override
  State<LengthConverter> createState() => _LengthConverterState();
}

class _LengthConverterState extends State<LengthConverter>
    with TickerProviderStateMixin {
  String? selectedFrom;
  String? selectedTo;
  double inputValue = 1.0;
  double result = 0.0;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _swapController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _swapRotation;

  final TextEditingController _textController = TextEditingController(
    text: '1.0',
  );

  final List<Map<String, dynamic>> units = [
    {'key': 'Meter', 'short': 'm', 'factor': 1.0, 'icon': Icons.straighten},
    {
      'key': 'Centimeter',
      'short': 'cm',
      'factor': 0.01,
      'icon': Icons.linear_scale,
    },
    {
      'key': 'Millimeter',
      'short': 'mm',
      'factor': 0.001,
      'icon': Icons.horizontal_rule,
    },
    {'key': 'Kilometer', 'short': 'km', 'factor': 1000.0, 'icon': Icons.route},
    {
      'key': 'Inch',
      'short': 'inch',
      'factor': 0.0254,
      'icon': Icons.crop_square,
    },
    {'key': 'Foot', 'short': 'ft', 'factor': 0.3048, 'icon': Icons.square_foot},
    {
      'key': 'Yard',
      'short': 'yd',
      'factor': 0.9144,
      'icon': Icons.settings_ethernet,
    },
    {
      'key': 'Mile',
      'short': 'mile',
      'factor': 1609.34,
      'icon': Icons.alt_route,
    },
    {'key': 'গজ', 'short': 'গজ', 'factor': 0.838, 'icon': Icons.analytics},
    {'key': 'হাত', 'short': 'হাত', 'factor': 0.4572, 'icon': Icons.back_hand},
    {
      'key': 'আঙ্গুল',
      'short': 'আঙ্গুল',
      'factor': 0.01875,
      'icon': Icons.fingerprint,
    },
    {'key': 'কস', 'short': 'কস', 'factor': 3200.0, 'icon': Icons.explore},
  ];

  final Map<String, String> unitBnNames = {
    'Meter': 'মিটার',
    'Centimeter': 'সেন্টিমিটার',
    'Millimeter': 'মিলিমিটার',
    'Kilometer': 'কিলোমিটার',
    'Inch': 'ইঞ্চি',
    'Foot': 'ফুট',
    'Yard': 'ইয়ার্ড',
    'Mile': 'মাইল',
    'গজ': 'গজ',
    'হাত': 'হাত',
    'আঙ্গুল': 'আঙ্গুল',
    'কস': 'কস',
  };

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _swapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _swapRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _swapController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _swapController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // Fixed convert() function
  void convert() {
    if (selectedFrom != null && selectedTo != null) {
      final fromFactor = (units.firstWhere(
        (e) => e['short'] == selectedFrom!,
      )['factor']).toDouble(); // convert safely
      final toFactor = (units.firstWhere(
        (e) => e['short'] == selectedTo!,
      )['factor']).toDouble(); // convert safely
      setState(() {
        result = inputValue * fromFactor / toFactor;
      });

      _scaleController.reset();
      _scaleController.forward();
    }
  }

  void swapUnits() {
    _swapController.forward().then((_) {
      final temp = selectedFrom;
      setState(() {
        selectedFrom = selectedTo;
        selectedTo = temp;
        convert();
      });
      _swapController.reverse();
    });
  }

  Widget _buildInputCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
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
              color: colorScheme.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calculate_outlined,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  S.t('value', widget.localeCode),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                suffixIcon: Icon(
                  Icons.edit_outlined,
                  color: colorScheme.primary.withOpacity(0.5),
                ),
              ),
              onChanged: (v) {
                setState(() {
                  // Ensure inputValue is always double
                  inputValue = double.tryParse(v) ?? 0.0;
                  convert();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitSelector(
    String label,
    String? value,
    Function(String?) onChanged,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final localeCode = widget.localeCode;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: colorScheme.primary,
            ),
            items: units
                .map(
                  (e) => DropdownMenuItem(
                    value: e['short'] as String,
                    child: Row(
                      children: [
                        Icon(
                          e['icon'] as IconData,
                          size: 20,
                          color: colorScheme.primary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            localeCode == 'bn'
                                ? '${unitBnNames[e['key']] ?? e['key']} (${e['short']})'
                                : '${S.t(e['key'], localeCode)} (${e['short']})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              onChanged(v);
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwapButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return RotationTransition(
      turns: _swapRotation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.swap_horiz, size: 28),
          color: Colors.white,
          onPressed: swapUnits,
          tooltip: S.t('swap_units', widget.localeCode),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.done_all,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  S.t('result', widget.localeCode),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    result.isNaN ? '0' : result.toStringAsFixed(6),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    selectedTo ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            selectedFrom = null;
            selectedTo = null;
            inputValue = 1.0;
            result = 0.0;
            _textController.text = '1.0';
          });
          HapticFeedback.mediumImpact();
        },
        icon: const Icon(Icons.clear_all, size: 22),
        label: Text(
          S.t('clear', widget.localeCode),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildInputCard(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildUnitSelector(
                    S.t('from', widget.localeCode),
                    selectedFrom,
                    (v) {
                      setState(() {
                        selectedFrom = v;
                        convert();
                      });
                    },
                    Icons.input,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildSwapButton(),
                ),
                Expanded(
                  child: _buildUnitSelector(
                    S.t('to', widget.localeCode),
                    selectedTo,
                    (v) {
                      setState(() {
                        selectedTo = v;
                        convert();
                      });
                    },
                    Icons.output,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildResultCard(),
            const SizedBox(height: 16),
            _buildClearButton(),
          ],
        ),
      ),
    );
  }
}
