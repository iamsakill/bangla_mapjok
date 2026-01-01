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
    {'key': 'Viss', 'short': 'ভিস', 'factor': 40, 'icon': Icons.inventory_2},
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

      // Animate result
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
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
