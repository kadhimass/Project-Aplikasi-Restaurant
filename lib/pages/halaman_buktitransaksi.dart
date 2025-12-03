import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_makanan/model/keranjang.dart';

class HalamanBuktiTransaksi extends StatelessWidget {
  final Keranjang keranjang;
  final String email;
  final String idTransaksi;
  final DateTime waktuTransaksi;
  final String? metodePembayaran;

  const HalamanBuktiTransaksi({
    super.key,
    required this.keranjang,
    required this.email,
    required this.idTransaksi,
    required this.waktuTransaksi,
    this.metodePembayaran,
  });

  @override
  Widget build(BuildContext context) {
    final totalAkhir = keranjang.hargaSetelahDiskon;
    final dapatDiskon = keranjang.dapatDiskon;
    final jumlahDiskon = keranjang.jumlahDiskon;
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Transaksi'),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Success
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    'Pembayaran Berhasil!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tampilkan info diskon jika ada
                  if (dapatDiskon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.discount, color: Colors.orange, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Anda Hemat ${formatRupiah.format(jumlahDiskon)}!',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'Terima kasih telah berbelanja di Warung Kita',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Transaksi
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Transaksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('ID Transaksi', idTransaksi),
                    _buildInfoRow('Tanggal', _formatTanggal(waktuTransaksi)),
                    _buildInfoRow('Waktu', _formatWaktu(waktuTransaksi)),
                    _buildInfoRow('Email', email),
                    if (metodePembayaran != null)
                      _buildInfoRow('Metode', metodePembayaran!),
                    // Tambahan: Status Diskon
                    _buildInfoRow(
                      'Status Diskon',
                      dapatDiskon ? 'Dapat Diskon' : 'Tidak Dapat Diskon',
                      valueColor: dapatDiskon ? Colors.green : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Detail Pesanan
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Pesanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...keranjang.items.map((item) => _buildItemRow(item)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ringkasan Pembayaran
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Pembayaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtotal
                    //formatRupiah.format('Subtotal', jumlahDiskon),
                    _buildSummaryRow('Subtotal', keranjang.totalHarga),

                    // Diskon
                    _buildSummaryRow(
                      'Diskon',
                      dapatDiskon ? -jumlahDiskon : 0,
                      isDiscount: dapatDiskon,
                    ),

                    const Divider(height: 24),

                    // Total Akhir
                    _buildSummaryRow(
                      'Total Pembayaran',
                      totalAkhir,
                      isTotal: true,
                    ),

                    // Info tambahan tentang diskon
                    if (dapatDiskon) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Anda mendapatkan diskon!',
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Diskon Rp10.000 untuk pembelian di atas Rp10.000',
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _simpanBuktiTransaksi(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.orange.shade400),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download, size: 20),
                        SizedBox(width: 8),
                        Text('Simpan Bukti'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Replace the stack and go to main screen
                      context.goNamed('main', extra: {'email': email});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, size: 20),
                        SizedBox(width: 8),
                        Text('Kembali ke Beranda'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Info Tambahan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Informasi:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pesanan Anda sedang diproses. Silahkan tunggu beberapa menit.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Simpan bukti transaksi ini sebagai referensi.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  // Info diskon tambahan
                  if (dapatDiskon) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Anda berhasil menghemat ${formatRupiah.format(jumlahDiskon)} dengan diskon spesial!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(ItemKeranjang item) {
    final subtotal = item.produk.harga * item.jumlah;
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.produk.gambar,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.fastfood, size: 24),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.produk.nama,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.jumlah} x ${formatRupiah.format(item.produk.harga)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            formatRupiah.format(subtotal),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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

  String _formatTanggal(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatWaktu(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _simpanBuktiTransaksi(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bukti transaksi berhasil disimpan ke galeri!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
