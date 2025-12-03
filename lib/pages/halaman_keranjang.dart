import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:menu_makanan/bloc/cart_bloc.dart';
import 'package:menu_makanan/bloc/cart_event.dart';
import 'package:menu_makanan/bloc/cart_state.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/produk.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:menu_makanan/pages/payment_method_page.dart';
import 'package:menu_makanan/model/transaksi.dart';

class HalamanKeranjang extends StatefulWidget {
  final String email;

  const HalamanKeranjang({super.key, required this.email});

  @override
  State<HalamanKeranjang> createState() => _HalamanKeranjangState();
}

class _HalamanKeranjangState extends State<HalamanKeranjang> {
  final formatRupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Fungsi untuk menambah item
  void _tambahItem(Produk produk) {
    context.read<CartBloc>().add(AddToCart(produk));
    _showSnackBar('${produk.nama} ditambahkan!', Colors.green);
  }

  // Fungsi untuk mengosongkan keranjang
  void _kosongkanKeranjang() {
    context.read<CartBloc>().add(ClearCart());
    _showSnackBar('Keranjang dikosongkan!', Colors.orange);
  }

  // Fungsi untuk mengurangi item
  void _kurangiItem(Produk produk) {
    context.read<CartBloc>().add(DecreaseQuantity(produk));
    _showSnackBar('${produk.nama} dikurangi!', Colors.orange);
  }

  // Fungsi untuk menghapus item
  void _hapusItem(Produk produk) {
    context.read<CartBloc>().add(RemoveFromCart(produk));
    _showSnackBar('${produk.nama} dihapus!', Colors.red);
  }

  // Fungsi untuk menampilkan snackbar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Fungsi checkout - buka pilihan metode pembayaran
  void _bayar() {
    final cartState = context.read<CartBloc>().state;
    if (cartState.keranjang.totalItem == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang Anda kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Kirimkan objek Keranjang langsung ke halaman pembayaran
    final keranjangSaatIni = cartState.keranjang;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PaymentMethodPage(keranjang: keranjangSaatIni, email: widget.email),
      ),
    );
  }

  // Proses checkout
  void _prosesCheckout() {
    final cartState = context.read<CartBloc>().state;
    // Simpan data keranjang sebelum dikosongkan
    final keranjangSebelumCheckout = Keranjang(
      initialItems: cartState.keranjang.items
          .map(
            (item) => ItemKeranjang(produk: item.produk, jumlah: item.jumlah),
          )
          .toList(),
    );

    // Generate ID transaksi unik
    final idTransaksi = 'WRKT${DateTime.now().millisecondsSinceEpoch}';
    final waktuTransaksi = DateTime.now();

    // Create Transaksi object
    final newTransaction = Transaksi(
      keranjang: keranjangSebelumCheckout,
      email: widget.email,
      idTransaksi: idTransaksi,
      waktuTransaksi: waktuTransaksi,
    );

    // Add transaction to provider
    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).addTransaction(newTransaction);

    // Kosongkan keranjang setelah checkout
    _kosongkanKeranjang();

    // Navigate to bukti transaksi using go_router
    context.pushNamed(
      'bukti',
      extra: {
        'keranjang': newTransaction.keranjang,
        'email': newTransaction.email,
        'idTransaksi': newTransaction.idTransaksi,
        'waktuTransaksi': newTransaction.waktuTransaksi,
      },
    );
  }

  // Widget untuk baris ringkasan - MOBILE FRIENDLY
  Widget _buildMobileSummaryRow(
    String label,
    double value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : Colors.grey.shade700,
            ),
          ),
          Text(
            isDiscount && value < 0
                ? '-${formatRupiah.format(value.abs())}'
                : formatRupiah.format(value),
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: isDiscount
                  ? Colors.green
                  : (isTotal ? Colors.orange : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              // Banner diskon jika eligible - MOBILE OPTIMIZED
              if (state.keranjang.dapatDiskon)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade300,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.discount, color: Colors.white, size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diskon Aktif!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Potongan Rp10.000',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '✓',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Daftar item keranjang - MOBILE OPTIMIZED
              Expanded(
                child: state.keranjang.items.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: state.keranjang.items.length,
                        itemBuilder: (context, index) {
                          final item = state.keranjang.items[index];
                          final subtotal = item.produk.harga * item.jumlah;

                          return _buildMobileCartItem(item, subtotal, index);
                        },
                      ),
              ),

              // Footer total dan checkout - MOBILE OPTIMIZED
              if (state.keranjang.items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Ringkasan harga
                      _buildMobileSummaryRow(
                        'Subtotal',
                        state.keranjang.totalHarga,
                      ),
                      _buildMobileSummaryRow(
                        'Diskon',
                        state.keranjang.dapatDiskon
                            ? -state.keranjang.jumlahDiskon
                            : 0,
                        isDiscount: state.keranjang.dapatDiskon,
                      ),

                      const Divider(height: 14),

                      // Total akhir
                      _buildMobileSummaryRow(
                        'Total Pembayaran',
                        state.keranjang.hargaSetelahDiskon,
                        isTotal: true,
                      ),

                      const SizedBox(height: 12),

                      // Tombol checkout
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _bayar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: Colors.orange.shade300,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payment, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'BAYAR',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Empty state untuk keranjang kosong
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Keranjang Kosong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tambahkan makanan favorit Anda\ndari menu beranda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCartItem(ItemKeranjang item, double subtotal, int index) {
    return Dismissible(
      key: Key('${item.produk.id}_$index'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hapus Item?'),
              content: Text('Hapus ${item.produk.nama} dari keranjang?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        _hapusItem(item.produk);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildSimpleImage(item.produk.gambar),
                ),
              ),

              const SizedBox(width: 12),

              // Info produk - layout vertikal untuk mobile
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk
                    Text(
                      item.produk.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Harga satuan
                    Text(
                      '${formatRupiah.format(item.produk.harga)}/Item',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Kontrol jumlah dan subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Kontrol jumlah
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              // Tombol kurang
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                color: Colors.red,
                                onPressed: () => _kurangiItem(item.produk),
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                              ),

                              // Jumlah
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  item.jumlah.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              // Tombol tambah
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                color: Colors.green,
                                onPressed: () => _tambahItem(item.produk),
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Subtotal
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Subtotal',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              formatRupiah.format(subtotal),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleImage(String gambarPath) {
    try {
      if (gambarPath.startsWith('http')) {
        return Image.network(
          gambarPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        );
      } else {
        return Image.asset(
          gambarPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        );
      }
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.fastfood, color: Colors.grey, size: 32),
    );
  }
}
