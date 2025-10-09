import 'package:flutter/material.dart';

class TombolFitur extends StatefulWidget {
  const TombolFitur({super.key});

  @override
  State<TombolFitur> createState() => _TombolFiturState();
}

class _TombolFiturState extends State<TombolFitur> {
  int _indexTerpilih = 0; // Menyimpan index menu yang sedang dipilih
  BottomNavigationBarType _tipeBottomNav = BottomNavigationBarType.fixed; // Tipe tampilan bottom navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigasi Bawah Sederhana'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan halaman yang sedang dipilih
            Text("Halaman Terpilih: ${_daftarItemNavBar[_indexTerpilih].label}"),
            const SizedBox(height: 20),
            
            // Opsi untuk mengganti tipe bottom navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Tipe BottomNavBar:"),
                const SizedBox(width: 16),
                DropdownButton<BottomNavigationBarType>(
                  hint: Text(_tipeBottomNav.name),
                  items: BottomNavigationBarType.values
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item.name),
                        ),
                      )
                      .toList(),
                  onChanged: (nilai) {
                    if (nilai == null) return;
                    setState(() {
                      _tipeBottomNav = nilai;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexTerpilih,
        selectedItemColor: const Color(0xff6200ee), // Warna saat dipilih
        unselectedItemColor: const Color(0xff757575), // Warna saat tidak dipilih
        type: _tipeBottomNav, // Tipe tampilan (fixed/shifting)
        onTap: (index) {
          setState(() {
            _indexTerpilih = index; // Mengubah halaman saat item diklik
          });
        },
        items: _daftarItemNavBar, // Daftar item menu
      ),
    );
  }
}

// Daftar item menu untuk bottom navigation
const _daftarItemNavBar = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined), // Icon tidak aktif
    activeIcon: Icon(Icons.home_rounded), // Icon aktif
    label: 'Beranda', // Label menu
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.shopping_cart_outlined),
    activeIcon: Icon(Icons.shopping_cart_rounded),
    label: 'Keranjang',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Profil',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.settings_outlined),
    activeIcon: Icon(Icons.settings_rounded),
    label: 'Pengaturan',
  ),
];