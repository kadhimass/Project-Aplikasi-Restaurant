import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:menu_makanan/halaman_riwayat.dart';
import 'package:menu_makanan/providers/theme_provider.dart';

//======================================================================
// WIDGET UTAMA HALAMAN PENGATURAN
//======================================================================
class HalamanPengaturan extends StatefulWidget {
  final String email;
  const HalamanPengaturan({super.key, required this.email});

  @override
  State<HalamanPengaturan> createState() => _HalamanPengaturanState();
}

class _HalamanPengaturanState extends State<HalamanPengaturan> {
  /// Menampilkan dialog konfirmasi sebelum keluar dari aplikasi.
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
                Navigator.of(context).pop(); // Tutup dialog
                // Ganti '/login' dengan nama rute halaman login Anda
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
      ),
      body: Center(
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
                _CustomListTile(
                  title: "Riwayat Transaksi",
                  icon: Icons.history_edu_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HalamanRiwayat(email: widget.email),
                      ),
                    );
                  },
                ),
                _CustomListTile(
                  title: "Opsi Lainnya",
                  icon: Icons.more_horiz_rounded,
                  trailing: PullDownButton(
                    itemBuilder: (context) => [
                      PullDownMenuItem(
                        title: 'Bantuan',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Membuka halaman bantuan...')),
                          );
                        },
                        icon: CupertinoIcons.question_circle,
                      ),
                      const PullDownMenuDivider(),
                      PullDownMenuItem(
                        title: 'Hapus Akun',
                        isDestructive: true,
                        onTap: () {
                          // Tambahkan logika untuk menampilkan dialog konfirmasi hapus akun
                        },
                        icon: CupertinoIcons.delete,
                      ),
                    ],
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.ellipsis_circle),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            _SingleSection(
              children: [
                const _CustomListTile(
                  title: "Tentang",
                  icon: Icons.info_outline_rounded,
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

//======================================================================
// WIDGET BANTUAN (HELPER WIDGETS)
//======================================================================

/// Widget untuk membuat satu item baris di halaman pengaturan.
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
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}

/// Widget untuk mengelompokkan beberapa `_CustomListTile` dalam satu seksi.
class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              title!.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
            ),
          ),
        Column(children: children),
      ],
    );
  }
}
