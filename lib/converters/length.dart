import 'package:flutter/material.dart';
import '../utils/localization.dart';

class LengthConverter extends StatefulWidget {
  final String localeCode;
  const LengthConverter({super.key, required this.localeCode});

  @override
  State<LengthConverter> createState() => _LengthConverterState();
}

class _LengthConverterState extends State<LengthConverter> {
  String? selectedFrom;
  String? selectedTo;
  double inputValue = 1.0;
  double result = 0.0;

  final List<Map<String, dynamic>> units = [
    {'key': 'Meter', 'short': 'm', 'factor': 1.0},
    {'key': 'Centimeter', 'short': 'cm', 'factor': 0.01},
    {'key': 'Millimeter', 'short': 'mm', 'factor': 0.001},
    {'key': 'Kilometer', 'short': 'km', 'factor': 1000},
    {'key': 'Inch', 'short': 'inch', 'factor': 0.0254},
    {'key': 'Foot', 'short': 'ft', 'factor': 0.3048},
    {'key': 'Yard', 'short': 'yd', 'factor': 0.9144},
    {'key': 'Mile', 'short': 'mile', 'factor': 1609.34},
    {'key': 'গজ', 'short': 'গজ', 'factor': 0.838},
    {'key': 'হাত', 'short': 'হাত', 'factor': 0.4572},
    {'key': 'আঙ্গুল', 'short': 'আঙ্গুল', 'factor': 0.01875},
    {'key': 'কস', 'short': 'কস', 'factor': 3200},
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
                color: Colors.blue.shade50,
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
