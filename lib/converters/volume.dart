import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/localization.dart';

class VolumeConverter extends StatefulWidget {
  final String localeCode;
  const VolumeConverter({super.key, required this.localeCode});

  @override
  State<VolumeConverter> createState() => _VolumeConverterState();
}

class _VolumeConverterState extends State<VolumeConverter>
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
    // Metric
    {'key': 'Liter', 'short': 'L', 'factor': 1.0, 'icon': Icons.water_drop},
    {
      'key': 'Milliliter',
      'short': 'mL',
      'factor': 0.001,
      'icon': Icons.opacity,
    },
    {
      'key': 'Cubic Meter',
      'short': 'm³',
      'factor': 1000.0,
      'icon': Icons.view_in_ar,
    },
    // Imperial
    {
      'key': 'Gallon',
      'short': 'gal',
      'factor': 3.78541,
      'icon': Icons.local_drink,
    },
    {
      'key': 'Quart',
      'short': 'qt',
      'factor': 0.946353,
      'icon': Icons.sports_bar,
    },
    {'key': 'Pint', 'short': 'pt', 'factor': 0.473176, 'icon': Icons.liquor},
    {
      'key': 'Cubic Inch',
      'short': 'cubic inch',
      'factor': 0.0163871,
      'icon': Icons.crop_3_2,
    },
    {
      'key': 'Cubic Foot',
      'short': 'cubic foot',
      'factor': 28.3168,
      'icon': Icons.square,
    },
    // Bangladeshi
    {
      'key': 'Chhatak',
      'short': 'চাটক',
      'factor': 0.012,
      'icon': Icons.local_cafe,
    },
    {'key': 'Bhari', 'short': 'ভারি', 'factor': 0.25, 'icon': Icons.coffee},
    {
      'key': 'Pathi / Puri',
      'short': 'পাথি / পুরি',
      'factor': 4.5,
      'icon': Icons.food_bank,
    },
    {'key': 'Khandi', 'short': 'খণ্ডি', 'factor': 25, 'icon': Icons.inventory},
    {'key': 'Bata', 'short': 'বাটা', 'factor': 0.875, 'icon': Icons.rice_bowl},
    {
      'key': 'Katori / Cup',
      'short': 'কাটি / কাপ',
      'factor': 0.2,
      'icon': Icons.emoji_food_beverage,
    },
    {'key': 'Ghari', 'short': 'ঘড়ি', 'factor': 2, 'icon': Icons.watch},
  ];

  final Map<String, String> unitBnNames = {
    'Liter': 'লিটার',
    'Milliliter': 'মিলিলিটার',
    'Cubic Meter': 'ঘন মিটার',
    'Gallon': 'গ্যালন',
    'Quart': 'কোয়ার্ট',
    'Pint': 'পিন্ট',
    'Cubic Inch': 'ঘন ইঞ্চি',
    'Cubic Foot': 'ঘন ফুট',
    'Chhatak': 'চাটক',
    'Bhari': 'ভারি',
    'Pathi / Puri': 'পাথি / পুরি',
    'Khandi': 'খণ্ডি',
    'Bata': 'বাটা',
    'Katori / Cup': 'কাটি / কাপ',
    'Ghari': 'ঘড়ি',
  };

  // BD units sequence for From → To dropdown
  final Map<String, List<String>> bdUnitAliases = {
    'চাটক': ['ভারি', 'পাথি / পুরি', 'খণ্ডি', 'বাটা', 'কাটি / কাপ', 'ঘড়ি'],
    'ভারি': ['পাথি / পুরি', 'খণ্ডি', 'বাটা', 'কাটি / কাপ', 'ঘড়ি'],
    'পাথি / পুরি': ['খণ্ডি', 'বাটা', 'কাটি / কাপ', 'ঘড়ি'],
    'খণ্ডি': ['বাটা', 'কাটি / কাপ', 'ঘড়ি'],
    'বাটা': ['কাটি / কাপ', 'ঘড়ি'],
    'কাটি / কাপ': ['ঘড়ি'],
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
    ValueChanged<String?> onChanged,
    IconData icon, {
    bool isFrom = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final localeCode = widget.localeCode;

    List<Map<String, dynamic>> filteredUnits = units;

    // Apply BD unit sequence for "To" dropdown only
    if (!isFrom &&
        selectedFrom != null &&
        bdUnitAliases.containsKey(selectedFrom!)) {
      final allowed = bdUnitAliases[selectedFrom!]!;
      filteredUnits = units.where((e) => allowed.contains(e['short'])).toList();
    }

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
            initialValue: filteredUnits.any((e) => e['short'] == value) ? value : null,
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
            items: filteredUnits
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
                Text(
                  S.t('result', widget.localeCode),
                  style: const TextStyle(
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
                    overflow: TextOverflow.ellipsis,
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
          label: Text(
            S.t('clear', widget.localeCode),
            style: const TextStyle(
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
                    isFrom: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    isFrom: false,
                  ),
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
