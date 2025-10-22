import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menu_makanan/model/makanan.dart';
import 'package:menu_makanan/model/minuman.dart';
import 'package:menu_makanan/model/produk.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';

class HalamanDetail extends StatefulWidget {
  final Produk produk;
  final VoidCallback? onTambahKeKeranjang;

  const HalamanDetail({
    super.key,
    required this.produk,
    this.onTambahKeKeranjang,
  });

  @override
  State<HalamanDetail> createState() => _HalamanDetailState();
}

class _HalamanDetailState extends State<HalamanDetail> {
  //late final WebViewController _controller;
  final bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
  
  // 2. BUAT OBJECT FORMATTER UNTUK MATA UANG RUPIAH
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp', 
      decimalDigits: 0
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produk.nama),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              widget.produk.gambar,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.fastfood,
                    color: Colors.grey,
                    size: 64,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.produk.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      AnimatedRatingStars(
                        initialRating: widget.produk.rating.toDouble(),
                        minRating: 0.0,
                        maxRating: 5.0,
                        filledColor: Colors.amber,
                        emptyColor: Colors.grey,
                        filledIcon: Icons.star,
                        halfFilledIcon: Icons.star_half,
                        emptyIcon: Icons.star_border,
                        onChanged: (double rating) {},
                        displayRatingValue: true,
                        interactiveTooltips: true,
                        customFilledIcon: Icons.star,
                        customHalfFilledIcon: Icons.star_half,
                        customEmptyIcon: Icons.star_border,
                        starSize: 30.0,
                        animationDuration: const Duration(milliseconds: 300),
                        animationCurve: Curves.easeInOut,
                        readOnly: true,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.produk.rating.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        // ==========================================================
                        // 3. GUNAKAN FORMATTER PADA HARGA PRODUK
                        // ==========================================================
                        currencyFormatter.format(widget.produk.harga),
                        // ==========================================================
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      /*Text(
                        'Rp${widget.produk.harga}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),*/
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.produk.deskripsi,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  if (widget.produk is Makanan)
                    _buildDetailMakanan(widget.produk as Makanan),
                  if (widget.produk is Minuman)
                    _buildDetailMinuman(widget.produk as Minuman),
                  const SizedBox(height: 24),
      
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.onTambahKeKeranjang != null) {
                          widget.onTambahKeKeranjang!();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.produk.nama} ditambahkan ke keranjang!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'TAMBAH KE KERANJANG',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildDetailMakanan(Makanan makanan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Makanan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Tingkat Kepedasan: '),
            Text(
              makanan.pedas ? 'Pedas' : 'Tidak Pedas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: makanan.pedas ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text('Kategori: '),
            Text(
              makanan.kategori,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailMinuman(Minuman minuman) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Minuman',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Suhu: '),
            Text(
              minuman.dingin ? 'Dingin' : 'Hangat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: minuman.dingin ? Colors.blue : Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text('Ukuran: '),
            Text(
              minuman.ukuran,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
