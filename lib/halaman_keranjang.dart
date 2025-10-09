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
    setState(() {
      // Refresh UI saja
    });
  }

  // Fungsi untuk menambah item
  void _tambahItem(Produk produk) {
    setState(() {
      widget.keranjang.tambahItem(produk);
    });
    _showSnackBar('${produk.nama} ditambahkan ke keranjang!', Colors.green);
  }

  // Fungsi untuk mengosongkan keranjang
  void _kosongkanKeranjang() {
    setState(() {
      widget.keranjang.kosongkan();
    });
    _showSnackBar('Keranjang berhasil dikosongkan!', Colors.orange);
  }

  // Fungsi untuk mengurangi item
  void _kurangiItem(Produk produk) {
    setState(() {
      widget.keranjang.kurangiItem(produk);
    });
    _showSnackBar('${produk.nama} dikurangi dari keranjang!', Colors.orange);
  }

  // Fungsi untuk menghapus item
  void _hapusItem(Produk produk) {
    setState(() {
      widget.keranjang.hapusItem(produk);
    });
    _showSnackBar('${produk.nama} dihapus dari keranjang!', Colors.red);
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
    
    _showSnackBar('Jumlah ${produk.nama} diupdate menjadi $jumlahBaru!', Colors.blue);
  }

  // Dialog untuk update jumlah dengan text field
  void _showUpdateDialog(Produk produk, int jumlahSekarang) {
    TextEditingController controller = TextEditingController(text: jumlahSekarang.toString());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Jumlah ${produk.nama}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Jumlah',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final jumlahBaru = int.tryParse(controller.text) ?? jumlahSekarang;
                Navigator.of(context).pop();
                _updateJumlahItem(produk, jumlahBaru);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi checkout yang sudah diperbaiki
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
        return AlertDialog(
          title: const Text('Bayar Sekarang'),
          content: Text(
            'Total: Rp${widget.keranjang.totalHarga.toStringAsFixed(0)}\n\nApakah Anda yakin ingin melanjutkan ke pembayaran?',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                
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
                
                // PERBAIKAN: Gunakan push biasa, bukan pushReplacement
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
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD DAN APPBAR DIHAPUS DARI SINI
    // Widget ini sekarang hanya mengembalikan konten untuk body
    return Column(
        children: [
          // Header info keranjang
          if (widget.keranjang.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.orange.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Item: ${widget.keranjang.totalItem}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total Harga: Rp${widget.keranjang.totalHarga.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

          // Daftar item keranjang
          Expanded(
            child: widget.keranjang.items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Keranjang Anda kosong',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tambahkan item dari menu beranda',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.keranjang.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.keranjang.items[index];
                      final subtotal = item.produk.harga * item.jumlah;
                      
                      return Dismissible(
                        key: Key('${item.produk.id}_$index'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Hapus Item'),
                                content: Text('Hapus ${item.produk.nama} dari keranjang?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          _hapusItem(item.produk);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 2,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.produk.gambar,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image_not_supported, size: 24),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              item.produk.nama,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rp${item.produk.harga.toStringAsFixed(0)} per item'),
                                Text(
                                  'Subtotal: Rp${subtotal.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tombol edit jumlah
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Colors.blue,
                                  onPressed: () {
                                    _showUpdateDialog(item.produk, item.jumlah);
                                  },
                                  tooltip: 'Edit Jumlah',
                                ),
                                // Tombol kurangi
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                  onPressed: () {
                                    _kurangiItem(item.produk);
                                  },
                                ),
                                // Jumlah item
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.jumlah.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Tombol tambah
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: Colors.green,
                                  onPressed: () {
                                    _tambahItem(item.produk);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Footer total dan checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal', style: TextStyle(fontSize: 16)),
                    Text(
                      'Rp${widget.keranjang.hargaDiskon?.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Diskon', style: TextStyle(fontSize: 16)),
                    Text(
                      widget.keranjang.totalHarga >= 50000 ? 'Diskon' : 'Rp10.000',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.keranjang.totalHarga >= 50000 ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp${(widget.keranjang.hargaDiskon! > 50000 ? widget.keranjang.hargaDiskon : widget.keranjang.hargaDiskon)?.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Bayar sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}
