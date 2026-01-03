import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/localization.dart';

class WeightConverter extends StatefulWidget {
  final String localeCode;
  const WeightConverter({super.key, required this.localeCode});

  @override
  State<WeightConverter> createState() => _WeightConverterState();
}

class _WeightConverterState extends State<WeightConverter>
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
    // Standard units
    {
      'key': 'Kilogram',
      'short': 'kg',
      'factor': 1.0,
      'icon': Icons.fitness_center,
    },
    {'key': 'Gram', 'short': 'g', 'factor': 0.001, 'icon': Icons.scale},
    {
      'key': 'Milligram',
      'short': 'mg',
      'factor': 0.000001,
      'icon': Icons.medication,
    },
    {
      'key': 'Tonne',
      'short': 't',
      'factor': 1000,
      'icon': Icons.local_shipping,
    },
    {
      'key': 'Pound',
      'short': 'lb',
      'factor': 0.453592,
      'icon': Icons.monitor_weight,
    },
    {'key': 'Ounce', 'short': 'oz', 'factor': 0.0283495, 'icon': Icons.coffee},
    {'key': 'Stone', 'short': 'st', 'factor': 6.35029, 'icon': Icons.person},
    // Bangladeshi traditional units
    {'key': 'Viss', 'short': 'ভিস', 'factor': 0.933, 'icon': Icons.inventory_2},
    {'key': 'Tola', 'short': 'তোলা', 'factor': 0.01166, 'icon': Icons.diamond},
    {'key': 'Chhatak', 'short': 'চাটক', 'factor': 0.01215, 'icon': Icons.grain},
  ];

  final Map<String, String> unitBnNames = {
    'Kilogram': 'কিলোগ্রাম',
    'Gram': 'গ্রাম',
    'Milligram': 'মিলিগ্রাম',
    'Tonne': 'টন',
    'Pound': 'পাউন্ড',
    'Ounce': 'আউন্স',
    'Stone': 'স্টোন',
    'Viss': 'ভিস',
    'Tola': 'তোলা',
    'Chhatak': 'চাটক',
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

  void convert() {
    if (selectedFrom != null && selectedTo != null) {
      final fromFactor =
          units.firstWhere((e) => e['short'] == selectedFrom!)['factor']
              as double;
      final toFactor =
          units.firstWhere((e) => e['short'] == selectedTo!)['factor']
              as double;
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
              colorScheme.primaryContainer.withOpacity(0.4),
              colorScheme.secondaryContainer.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.05),
              blurRadius: 40,
              offset: const Offset(0, 16),
              spreadRadius: -8,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.15),
                        colorScheme.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.calculate_outlined,
                    color: colorScheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  S.t('value', widget.localeCode),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                  letterSpacing: -0.5,
                ),
                decoration: InputDecoration(
                  filled: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.edit_outlined,
                      color: colorScheme.primary.withOpacity(0.4),
                      size: 24,
                    ),
                  ),
                ),
                onChanged: (v) {
                  setState(() {
                    inputValue = double.tryParse(v) ?? 0.0;
                    convert();
                  });
                },
              ),
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
    IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final localeCode = widget.localeCode;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: colorScheme.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: units.any((e) => e['short'] == value) ? value : null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
            ),
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: colorScheme.primary,
              size: 24,
            ),
            items: units
                .map(
                  (e) => DropdownMenuItem(
                    value: e['short'] as String,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            e['icon'] as IconData,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            localeCode == 'bn'
                                ? '${unitBnNames[e['key']] ?? e['key']} (${e['short']})'
                                : '${S.t(e['key'], localeCode)} (${e['short']})',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              letterSpacing: 0.1,
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
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 10),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: swapUnits,
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Icon(
                Icons.swap_horiz,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
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
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.2),
              blurRadius: 40,
              offset: const Offset(0, 20),
              spreadRadius: -8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.done_all,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Result',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    result.isNaN ? '0' : result.toStringAsFixed(6),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    selectedTo ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 0.3,
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
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colorScheme.error.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: -2,
            ),
          ],
        ),
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
          icon: const Icon(Icons.clear_all, size: 24),
          label: const Text(
            'Clear',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.errorContainer,
            foregroundColor: colorScheme.onErrorContainer,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
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
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _buildUnitSelector('From', selectedFrom, (v) {
                    setState(() {
                      selectedFrom = v;
                      convert();
                    });
                  }, Icons.input),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildSwapButton(),
                ),
                Expanded(
                  child: _buildUnitSelector('To', selectedTo, (v) {
                    setState(() {
                      selectedTo = v;
                      convert();
                    });
                  }, Icons.output),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _buildResultCard(),
            const SizedBox(height: 20),
            _buildClearButton(),
          ],
        ),
      ),
    );
  }
}
