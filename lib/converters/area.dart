import 'package:flutter/material.dart';
import '../utils/localization.dart';

class AreaConverter extends StatefulWidget {
  final String localeCode;
  const AreaConverter({super.key, required this.localeCode});

  @override
  State<AreaConverter> createState() => _AreaConverterState();
}

class _AreaConverterState extends State<AreaConverter> {
  String? selectedFrom;
  String? selectedTo;
  double inputValue = 1.0;
  double result = 0.0;

  final List<Map<String, dynamic>> units = [
    // Metric
    {'key': 'Square Meter', 'short': 'm²', 'factor': 1.0},
    {'key': 'Hectare', 'short': 'ha', 'factor': 10000.0},
    {'key': 'Square Kilometer', 'short': 'km²', 'factor': 1000000.0},
    // Imperial
    {'key': 'Square Foot', 'short': 'ft²', 'factor': 0.092903},
    {'key': 'Square Yard', 'short': 'yd²', 'factor': 0.836127},
    {'key': 'Acre', 'short': 'acre', 'factor': 4046.86},
    // Bangladeshi
    {'key': 'Bigha', 'short': 'বিঘা', 'factor': 13340.0},
    {'key': 'Katha', 'short': 'কাঠা', 'factor': 666.7},
    {'key': 'Decimal', 'short': 'decimal', 'factor': 40.4686},
    {'key': 'Lecha', 'short': 'লেচা', 'factor': 33.3},
  ];

  final Map<String, String> unitBnNames = {
    'Square Meter': 'বর্গ মিটার',
    'Hectare': 'হেক্টর',
    'Square Kilometer': 'বর্গ কিলোমিটার',
    'Square Foot': 'বর্গ ফুট',
    'Square Yard': 'বর্গ ইয়ার্ড',
    'Acre': 'একর',
    'Bigha': 'বিঘা',
    'Katha': 'কাঠা',
    'Decimal': 'ডেসিমাল',
    'Lecha': 'লেচা',
  };

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
    }
  }

  void swapUnits() {
    final temp = selectedFrom;
    setState(() {
      selectedFrom = selectedTo;
      selectedTo = temp;
      convert();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = widget.localeCode;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: S.t('value', localeCode),
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) {
                setState(() {
                  inputValue = double.tryParse(v) ?? 0.0;
                  convert();
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: S.t('from', localeCode),
                    ),
                    initialValue: selectedFrom,
                    items: units
                        .map(
                          (e) => DropdownMenuItem(
                            value: e['short'] as String,
                            child: Text(
                              localeCode == 'bn'
                                  ? '${unitBnNames[e['key']] ?? e['key']} (${e['short']})'
                                  : '${S.t(e['key'], localeCode)} (${e['short']})',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedFrom = v;
                        convert();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz, size: 32),
                  onPressed: swapUnits,
                  tooltip: S.t('swap_units', localeCode),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: S.t('to', localeCode),
                    ),
                    initialValue: selectedTo,
                    items: units
                        .map(
                          (e) => DropdownMenuItem(
                            value: e['short'] as String,
                            child: Text(
                              localeCode == 'bn'
                                  ? '${unitBnNames[e['key']] ?? e['key']} (${e['short']})'
                                  : '${S.t(e['key'], localeCode)} (${e['short']})',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedTo = v;
                        convert();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                result.isNaN
                    ? '${S.t('result', localeCode)}: 0'
                    : '${S.t('result', localeCode)}: $result ${selectedTo ?? ""}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  selectedFrom = null;
                  selectedTo = null;
                  inputValue = 1.0;
                  result = 0.0;
                });
              },
              icon: const Icon(Icons.clear),
              label: Text(S.t('clear', localeCode)),
            ),
          ],
        ),
      ),
    );
  }
}
