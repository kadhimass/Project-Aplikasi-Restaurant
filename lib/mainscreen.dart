import 'package:flutter/material.dart';
import 'package:menu_makanan/halaman_beranda.dart';
import 'package:menu_makanan/halaman_keranjang.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/tombol/profil.dart';
import 'package:menu_makanan/tombol/pengaturan.dart';

class MainScreen extends StatefulWidget {
  final String email;
  const MainScreen({super.key, required this.email});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final Keranjang _keranjang = Keranjang();

  late final List<String> _judulAppBar;

  @override
  void initState() {
    super.initState();
    _judulAppBar = [
      'Selamat Datang, ${widget.email}',
      'Keranjang Belanja',
      'Profil Pengguna',
      'Pengaturan'
          'Riwayat Transaksi',
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(produk) {
    setState(() {
      _keranjang.tambahItem(produk);
      _showSnackBar('${produk.nama} ditambahkan ke keranjang!', Colors.green);
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _kosongkanKeranjang() {
    setState(() {
      _keranjang.kosongkan();
    });
    _showSnackBar('Keranjang berhasil dikosongkan!', Colors.orange);
  }

  void _updateKeranjang() {
    setState(() {
      // Cukup refresh UI
    });
  }

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

  List<Widget> _buildAppBarActions() {
    switch (_selectedIndex) {
      case 0: // Halaman Beranda
        return [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 1; // Pindah ke tab keranjang
              });
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1; // Pindah ke tab keranjang
                        });
                      },
                      tooltip: 'Keranjang Belanja',
                    ),
                    if (_keranjang.totalItem > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            _keranjang.totalItem.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 2),
                Text(
                  'Rp${_keranjang.totalHarga.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
        ];
      case 1: // Halaman Keranjang
        return [
          if (_keranjang.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Kosongkan Keranjang'),
                      content: const Text(
                        'Yakin ingin mengosongkan seluruh keranjang?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _kosongkanKeranjang();
                          },
                          child: const Text('Ya, Kosongkan'),
                        ),
                      ],
                    );
                  },
                );
              },
              tooltip: 'Kosongkan Keranjang',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _updateKeranjang,
            tooltip: 'Refresh Keranjang',
          ),
        ];
      default: // Halaman lain (Profil, Pengaturan)
        return [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Keluar',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definisikan halaman di sini agar selalu mendapatkan data terbaru
    final List<Widget> pages = [
      HalamanBeranda(
        keranjang: _keranjang,
        email: widget.email,
        onAddToCart: _addToCart,
      ),
      HalamanKeranjang(keranjang: _keranjang, email: widget.email),
      HalamanProfil(email: widget.email),
      HalamanPengaturan(email: widget.email),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_judulAppBar[_selectedIndex]),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        actions: _buildAppBarActions(),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: const Color(0xff757575),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
