import 'package:flutter/material.dart';
import '../utils/localization.dart';

class WeightConverter extends StatefulWidget {
  final String localeCode;
  const WeightConverter({super.key, required this.localeCode});

  @override
  State<WeightConverter> createState() => _WeightConverterState();
}

class _WeightConverterState extends State<WeightConverter> {
  String? selectedFrom;
  String? selectedTo;
  double inputValue = 1.0;
  double result = 0.0;

  final List<Map<String, dynamic>> units = [
    {'key': 'Kilogram', 'short': 'kg', 'factor': 1.0},
    {'key': 'Gram', 'short': 'g', 'factor': 0.001},
    {'key': 'Milligram', 'short': 'mg', 'factor': 0.000001},
    {'key': 'Tonne', 'short': 't', 'factor': 1000},
    {'key': 'Pound', 'short': 'lb', 'factor': 0.453592},
    {'key': 'Ounce', 'short': 'oz', 'factor': 0.0283495},
    {'key': 'Stone', 'short': 'st', 'factor': 6.35029},
    {'key': 'Viss', 'short': 'ভিস', 'factor': 40},
    {'key': 'Tola', 'short': 'তোলা', 'factor': 0.01166},
    {'key': 'Chhatak', 'short': 'চাটক', 'factor': 0.01215},
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
                                  ? "${unitBnNames[e['key']] ?? e['key']} (${e['short']})"
                                  : "${S.t(e['key'], localeCode)} (${e['short']})",
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
                                  ? "${unitBnNames[e['key']] ?? e['key']} (${e['short']})"
                                  : "${S.t(e['key'], localeCode)} (${e['short']})",
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
                color: Colors.amber.shade50,
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
