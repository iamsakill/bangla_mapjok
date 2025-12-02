import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/locale_provider.dart';
import '../utils/localization.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.t('choose_language', locale.locale.languageCode)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await locale.setLocale('bn');
                Navigator.of(context).pop();
              },
              child: Text('${S.t('bangla', 'en')} - ${S.t('bangla', 'bn')}'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await locale.setLocale('en');
                Navigator.of(context).pop();
              },
              child: Text(S.t('english', 'en')),
            ),
          ],
        ),
      ),
    );
  }
}
