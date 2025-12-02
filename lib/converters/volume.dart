import 'package:flutter/material.dart';
import '../utils/localization.dart';

class VolumeConverter extends StatefulWidget {
  final String localeCode;
  const VolumeConverter({super.key, required this.localeCode});

  @override
  State<VolumeConverter> createState() => _VolumeConverterState();
}

class _VolumeConverterState extends State<VolumeConverter> {
  String? selectedFrom;
  String? selectedTo;
  double inputValue = 1.0;
  double result = 0.0;

  final List<Map<String, dynamic>> units = [
    // Metric
    {'key': 'Liter', 'short': 'L', 'factor': 1.0},
    {'key': 'Milliliter', 'short': 'mL', 'factor': 0.001},
    {'key': 'Cubic Meter', 'short': 'm³', 'factor': 1000.0},
    // Imperial
    {'key': 'Gallon', 'short': 'gal', 'factor': 3.78541},
    {'key': 'Quart', 'short': 'qt', 'factor': 0.946353},
    {'key': 'Pint', 'short': 'pt', 'factor': 0.473176},
    {'key': 'Cubic Inch', 'short': 'cubic inch', 'factor': 0.0163871},
    {'key': 'Cubic Foot', 'short': 'cubic foot', 'factor': 28.3168},
    // Bangladeshi
    {'key': 'Chhatak', 'short': 'চাটক', 'factor': 0.012},
    {'key': 'Bhari', 'short': 'ভারি', 'factor': 0.25},
    {'key': 'Pathi / Puri', 'short': 'পাথি / পুরি', 'factor': 4.5},
    {'key': 'Khandi', 'short': 'খণ্ডি', 'factor': 25},
    {'key': 'Bata', 'short': 'বাটা', 'factor': 0.875},
    {'key': 'Katori / Cup', 'short': 'কাটি / কাপ', 'factor': 0.2},
    {'key': 'Ghari', 'short': 'ঘড়ি', 'factor': 2},
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
                color: Colors.orange.shade50,
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
