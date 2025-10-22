import 'package:flutter/material.dart';
import 'package:menu_makanan/halaman_buktitransaksi.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/produk.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:menu_makanan/model/transaksi.dart';

class HalamanKeranjang extends StatefulWidget {
  final Keranjang keranjang;
  final String email;
  
  const HalamanKeranjang({super.key, required this.keranjang, required this.email});

  @override
  State<HalamanKeranjang> createState() => _HalamanKeranjangState();
}

class _HalamanKeranjangState extends State<HalamanKeranjang> {
  // Fungsi untuk update keranjang
  void _updateKeranjang() {
    setState(() {});
  }

  // Fungsi untuk menambah item
  void _tambahItem(Produk produk) {
    setState(() {
      widget.keranjang.tambahItem(produk);
    });
    _showSnackBar('${produk.nama} ditambahkan!', Colors.green);
  }

  // Fungsi untuk mengosongkan keranjang
  void _kosongkanKeranjang() {
    setState(() {
      widget.keranjang.kosongkan();
    });
    _showSnackBar('Keranjang dikosongkan!', Colors.orange);
  }

  // Fungsi untuk mengurangi item
  void _kurangiItem(Produk produk) {
    setState(() {
      widget.keranjang.kurangiItem(produk);
    });
    _showSnackBar('${produk.nama} dikurangi!', Colors.orange);
  }

  // Fungsi untuk menghapus item
  void _hapusItem(Produk produk) {
    setState(() {
      widget.keranjang.hapusItem(produk);
    });
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

  // Fungsi update jumlah item
  void _updateJumlahItem(Produk produk, int jumlahBaru) {
    if (jumlahBaru <= 0) {
      _hapusItem(produk);
      return;
    }

    setState(() {
      final existingItemIndex = widget.keranjang.items.indexWhere(
        (item) => item.produk.id == produk.id
      );
      
      if (existingItemIndex != -1) {
        widget.keranjang.hapusItem(produk);
        
        for (int i = 0; i < jumlahBaru; i++) {
          widget.keranjang.tambahItem(produk);
        }
      }
    });
    
    _showSnackBar('Jumlah ${produk.nama} diupdate!', Colors.blue);
  }

  // Dialog untuk update jumlah dengan text field - MOBILE FRIENDLY
  void _showUpdateDialog(Produk produk, int jumlahSekarang) {
    TextEditingController controller = TextEditingController(text: jumlahSekarang.toString());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Update Jumlah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  produk.nama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final jumlahBaru = int.tryParse(controller.text) ?? jumlahSekarang;
                          Navigator.of(context).pop();
                          _updateJumlahItem(produk, jumlahBaru);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fungsi checkout - MOBILE OPTIMIZED
  void _checkout() {
    if (widget.keranjang.totalItem == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang Anda kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart_checkout, color: Colors.orange, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Konfirmasi Pembayaran',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Ringkasan harga
                _buildMobileSummaryRow('Subtotal', widget.keranjang.totalHarga),
                
                if (widget.keranjang.dapatDiskon) 
                  _buildMobileSummaryRow('Diskon', -widget.keranjang.jumlahDiskon, isDiscount: true),
                
                const Divider(height: 20),
                
                _buildMobileSummaryRow('Total', widget.keranjang.hargaSetelahDiskon, isTotal: true),
                
                if (widget.keranjang.dapatDiskon) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.celebration, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Hemat Rp10.000!',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 20),
                Text(
                  'Lanjutkan pembayaran?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Tombol aksi
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _prosesCheckout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Bayar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Proses checkout
  void _prosesCheckout() {
    // Simpan data keranjang sebelum dikosongkan
    final keranjangSebelumCheckout = Keranjang(
      initialItems: widget.keranjang.items.map((item) =>
        ItemKeranjang(produk: item.produk, jumlah: item.jumlah)
      ).toList(),
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
    Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);

    // Kosongkan keranjang setelah checkout
    _kosongkanKeranjang();
    
    // Navigate to bukti transaksi
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanBuktiTransaksi(
          keranjang: newTransaction.keranjang,
          email: newTransaction.email,
          idTransaksi: newTransaction.idTransaksi,
          waktuTransaksi: newTransaction.waktuTransaksi,
        ),
      ),
    );
  }

  // Widget untuk baris ringkasan - MOBILE FRIENDLY
  Widget _buildMobileSummaryRow(String label, double value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
              ? '-Rp${value.abs().toStringAsFixed(0)}'
              : 'Rp${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isDiscount ? Colors.green : (isTotal ? Colors.orange : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    
    return Scaffold(
      body: Column(
        children: [
          // Header info keranjang - MOBILE OPTIMIZED
          if (widget.keranjang.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade50, Colors.orange.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keranjang Anda',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        Text(
                          '${widget.keranjang.totalItem} item',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp${widget.keranjang.hargaSetelahDiskon.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        if (widget.keranjang.dapatDiskon)
                          Text(
                            'Hemat Rp10.000!',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Banner diskon jika eligible - MOBILE OPTIMIZED
          if (widget.keranjang.dapatDiskon)
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            child: widget.keranjang.items.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.keranjang.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.keranjang.items[index];
                      final subtotal = item.produk.harga * item.jumlah;
                      
                      return _buildMobileCartItem(item, subtotal, index);
                    },
                  ),
          ),
          
          // Footer total dan checkout - MOBILE OPTIMIZED
          if (widget.keranjang.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
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
                  _buildMobileSummaryRow('Subtotal', widget.keranjang.totalHarga),
                  _buildMobileSummaryRow(
                    'Diskon', 
                    widget.keranjang.dapatDiskon ? -widget.keranjang.jumlahDiskon : 0,
                    isDiscount: widget.keranjang.dapatDiskon,
                  ),
                  
                  const Divider(height: 16),
                  
                  // Total akhir
                  _buildMobileSummaryRow(
                    'Total Pembayaran',
                    widget.keranjang.hargaSetelahDiskon,
                    isTotal: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tombol checkout
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _checkout,
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
                            'CHECKOUT',
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
              child: Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey.shade400),
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
            ElevatedButton(
              onPressed: () {
              // Kembali ke route pertama (biasanya beranda)
              //Navigator.of(context).popUntil((route) => route.isFirst);
              // Jika Anda menggunakan named route '/beranda', ganti dengan:
              Navigator.of(context).pushNamedAndRemoveUntil('/beranda', (route) => false);
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
              'Mulai Belanja',
              style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Item keranjang untuk mobile
  // Item keranjang untuk mobile - VERSI DIPERBAIKI
Widget _buildMobileCartItem(ItemKeranjang item, double subtotal, int index) {
  final isSmallScreen = MediaQuery.of(context).size.width < 360;
  
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
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
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
            // Gambar produk - lebih compact
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color : Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildSimpleImage(item.produk.gambar),
             
                /*image: DecorationImage(
                  image: NetworkImage(item.produk.gambar),
                  fit: BoxFit.cover,
                ),*/
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
                    'Rp${item.produk.harga.toStringAsFixed(0)}/item',
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
                              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            'Rp${subtotal.toStringAsFixed(0)}',
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
                  
                  // Tombol edit jumlah (opsional, untuk akses cepat)
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _showUpdateDialog(item.produk, item.jumlah);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 12, color: Colors.blue.shade700),
                            const SizedBox(width: 4),
                            Text(
                              'Edit Jumlah',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
  
  
  /*Widget _buildMobileCartItem(ItemKeranjang item, double subtotal, int index) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    
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
                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Gambar produk
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(item.produk.gambar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Info produk
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.produk.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp${item.produk.harga.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp${subtotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Kontrol jumlah
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  // Tombol edit
                  IconButton(
                    icon: Icon(Icons.edit, size: 18),
                    color: Colors.blue,
                    onPressed: () {
                      _showUpdateDialog(item.produk, item.jumlah);
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  
                  // Kontrol jumlah
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.jumlah.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  
                  // Tombol tambah/kurang
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, size: 16),
                        color: Colors.red,
                        onPressed: () => _kurangiItem(item.produk),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, size: 16),
                        color: Colors.green,
                        onPressed: () => _tambahItem(item.produk),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/
  
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
    child: const Icon(
      Icons.fastfood,
      color: Colors.grey,
      size: 32,
    ),
  );
}
  
}