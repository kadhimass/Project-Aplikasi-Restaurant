import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_makanan/halaman_riwayat.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/theme_provider.dart';

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
                Navigator.pushReplacementNamed(context, '/login');
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
        //constraints: const BoxConstraints(maxWidth: 400),
        child: ListView(
          children: [
            _SingleSection(
              title: "Umum",
              children: [
                _CustomListTile(
                  title: "Mode Gelap",
                  icon: Icons.dark_mode_outlined,
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(value),
                  ),
                ),
                const _CustomListTile(
                  title: "Notifikasi",
                  icon: Icons.notifications_none_rounded,
                ),
                const _CustomListTile(
                  title: "Status Keamanan",
                  icon: CupertinoIcons.lock_shield,
                ),
              ],
            ),
            const Divider(),
            _SingleSection(
              title: "Organisasi",
              children: [
                const _CustomListTile(
                  title: "Profil",
                  icon: Icons.person_outline_rounded,
                ),
                const _CustomListTile(
                  title: "Keranjang",
                  icon: Icons.shopping_cart_checkout_outlined,
                ),
                _CustomListTile(
                  title: "Riwayat Transaksi",
                  icon: Icons.history_edu_outlined,
                  onTap: () {
                    // Navigator.of(context).pop(); // Consider if this is needed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HalamanRiwayat(email: widget.email),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            _SingleSection(
              children: [
                const _CustomListTile(
                  title: "Tentang",
                  icon: Icons.info_outline_rounded,
                  onTap: null,
                ),
                _CustomListTile(
                  title: "Keluar",
                  icon: Icons.exit_to_app_rounded,
                  onTap: _logout,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
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