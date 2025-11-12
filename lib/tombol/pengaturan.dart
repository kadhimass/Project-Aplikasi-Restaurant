import 'package:flutter/material.dart';
import 'package:menu_makanan/halaman_about_us.dart';
import 'package:menu_makanan/halaman_riwayat.dart';
import 'package:menu_makanan/main.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/theme_provider.dart';
import '../halaman_webview.dart';
import 'package:go_router/go_router.dart';

class HalamanPengaturan extends StatefulWidget {
  final String email;
  const HalamanPengaturan({super.key, required this.email});

  @override
  State<HalamanPengaturan> createState() => _HalamanPengaturanState();
}

class _HalamanPengaturanState extends State<HalamanPengaturan> {
  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Replace stack and go to login
                context.goNamed('login');
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Center(
      child: Container(
        child: ListView(
          children: [
            _SingleSection(
              title: "Umum",
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.dark_mode_outlined,
                    color: Colors.orange,
                  ),
                  title: const Text("Mode Gelap"),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(value),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.security_outlined,
                    color: Colors.orange,
                  ),
                  title: const Text("Status Keamanan"),
                  onTap: () {
                    context.pushNamed(
                      'webview',
                      extra: {
                        'title': 'Status Keamanan',
                        'url':
                            'https://drive.google.com/drive/folders/1YUHXOt886dwnQr8IpQN9u4GtCKXp5PL_?usp=sharing',
                      },
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            _SingleSection(
              title: "Organisasi",
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.orange,
                  ),
                  title: const Text("Profil"),
                  onTap: () {
                    context.pushNamed('profil', extra: {'email': widget.email});
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.history_edu_outlined,
                    color: Colors.orange,
                  ),
                  title: const Text("Riwayat Transaksi"),
                  onTap: () {
                    context.pushNamed(
                      'riwayat',
                      extra: {'email': widget.email},
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            _SingleSection(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                  ),
                  title: const Text("About Us"),
                  onTap: () {
                    context.pushNamed('about');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.orange,
                  ),
                  title: const Text("Tentang Aplikasi"),
                  onTap: _tentangaplikasi,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.orange,
                  ),
                  title: const Text("Keluar"),
                  onTap: _logout,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _tentangaplikasi() {
    showAboutDialog(
      context: context,
      applicationName: 'Menu Makanan',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Menu Makanan',
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            'Aplikasi Menu Makanan adalah platform yang menyediakan berbagai pilihan menu makanan lezat dan bergizi untuk memenuhi kebutuhan kuliner Anda.',
          ),
        ),
      ],
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(children: children),
      ],
    );
  }
}
