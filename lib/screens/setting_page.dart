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

    return Scaffold(
      appBar: AppBar(
        title: Text(isBangla ? 'সেটিংস' : 'Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme
          Text(
            isBangla ? 'দৃশ্যমানতা' : 'Appearance',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text(isBangla ? 'থিম মোড' : 'Theme Mode'),
            subtitle: Text(
              isBangla ? 'হালকা, অন্ধকার বা সিস্টেম' : 'Light, Dark or System',
            ),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
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
          const SizedBox(height: 20),

          // Language
          Text(
            isBangla ? 'ভাষা' : 'Language',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text(isBangla ? 'অ্যাপ ভাষা' : 'App Language'),
            trailing: DropdownButton<String>(
              value: localeProvider.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text("English")),
                DropdownMenuItem(value: 'bn', child: Text("বাংলা")),
              ],
              onChanged: (code) {
                if (code != null) {
                  localeProvider.setLocale(code); // ✅ pass string as expected
                }
              },
            ),
          ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),

          // Logout
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.logout),
              label: Text(isBangla ? 'লগ আউট' : 'Logout'),
              onPressed: () async {
                await auth.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
