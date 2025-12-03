import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_state.dart';
import 'package:menu_makanan/features/produk/presentation/pages/produk_list_page.dart';
import 'package:menu_makanan/features/cart/presentation/pages/cart_page.dart'
    as cart_pages;
import 'package:menu_makanan/tombol/profil.dart';
import 'package:menu_makanan/tombol/pengaturan.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final String email;
  const MainScreen({super.key, required this.email});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  // Keranjang lokal dihapus — gunakan CartBloc untuk menyimpan state keranjang
  final formatRupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  late final List<String> _judulAppBar;

  @override
  void initState() {
    super.initState();
    _judulAppBar = [
      'Selamat Datang, ${widget.email}',
      'Keranjang Belanja',
      'Profil Pengguna',
      'Pengaturan',
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
    // Kosongkan melalui CartBloc sehingga semua listener ter-update
    context.read<CartBloc>().add(ClearCart());
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
                context.goNamed('login');
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          switch (_selectedIndex) {
            case 0: // Halaman Beranda
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1; // Pindah ke tab keranjang
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
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
                          if (state.cart.totalItem > 0)
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
                                  state.cart.totalItem.toString(),
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
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          formatRupiah.format(state.cart.totalHarga),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            case 1: // Halaman Keranjang
              return Row(
                children: [
                  if (state.cart.items.isNotEmpty)
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
                ],
              );
            default: // Halaman lain (Profil, Pengaturan)
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _logout,
                tooltip: 'Keluar',
              );
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Ambil cart dari Bloc agar UI selalu sinkron
    context.watch<CartBloc>(); // Watch for cart updates

    // Definisikan halaman di sini agar selalu mendapatkan data terbaru
    final List<Widget> pages = [
      ProdukListPage(email: widget.email),
      cart_pages.HalamanKeranjangPage(email: widget.email),
      HalamanProfil(email: widget.email),
      HalamanPengaturan(email: widget.email),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_judulAppBar[_selectedIndex]),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        leading: _selectedIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0; // Kembali ke beranda
                  });
                },
                tooltip: 'Kembali ke Beranda',
              )
            : null,
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
