import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/locale_provider.dart';
import '../services/auth_service.dart';
import '../utils/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AuthService>(context);
    final isBangla = localeProvider.isBangla;
    final loggedIn = auth.currentUser != null; // check if user is logged in

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Appearance
            Text(
              isBangla ? 'দৃশ্যমানতা' : 'Appearance',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                isExpanded: true,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(isBangla ? 'হালকা' : 'Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(isBangla ? 'অন্ধকার' : 'Dark'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(isBangla ? 'সিস্টেম' : 'System'),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) themeProvider.setTheme(mode);
                },
              ),
            ),
            const SizedBox(height: 24),

            // App Language
            Text(
              isBangla ? 'ভাষা' : 'Language',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: DropdownButton<String>(
                value: localeProvider.locale.languageCode,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text("English")),
                  DropdownMenuItem(value: 'bn', child: Text("বাংলা")),
                ],
                onChanged: (code) {
                  if (code != null) localeProvider.setLocale(code);
                },
              ),
            ),
            const SizedBox(height: 32),

            // Divider
            const Divider(color: Colors.black12, thickness: 1),
            const SizedBox(height: 20),

            // Logout Button (only if logged in)
            if (loggedIn)
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await auth.signOut();
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      isBangla ? 'লগ আউট' : 'Logout',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
