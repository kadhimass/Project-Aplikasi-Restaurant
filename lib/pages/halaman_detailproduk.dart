import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:menu_makanan/bloc/cart_bloc.dart';
import 'package:menu_makanan/bloc/cart_event.dart';
import 'package:menu_makanan/model/produk.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:menu_makanan/services/rating_service.dart';

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
  final RatingService _ratingService = RatingService();
  double? _userRating;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  Future<void> _loadUserRating() async {
    final rating = await _ratingService.getRating(widget.produk.id);
    if (mounted) {
      setState(() {
        _userRating = rating;
      });
    }
  }

  Future<void> _saveUserRating(double rating) async {
    await _ratingService.saveRating(widget.produk.id, rating);
    if (mounted) {
      setState(() {
        _userRating = rating;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rating berhasil disimpan: ${rating.toStringAsFixed(1)} ⭐'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format Rupiah
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
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
            // Gambar Produk
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

            // Detail Produk
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk
                  Text(
                    widget.produk.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating Pengguna (Interaktif)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Beri Rating:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      RatingBar.builder(
                        initialRating: _userRating ?? 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 40,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          _saveUserRating(rating);
                        },
                        glow: true,
                        glowColor: Colors.amber.withOpacity(0.5),
                      ),
                      if (_userRating != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Rating Anda: ${_userRating!.toStringAsFixed(1)} ⭐',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Harga
                  Row(
                    children: [
                      Text(
                        formatRupiah.format(widget.produk.harga),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi
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

                  // Detail Spesifik (Makanan/Minuman)
                  if (widget.produk is Makanan)
                    _buildDetailMakanan(widget.produk as Makanan),
                  if (widget.produk is Minuman)
                    _buildDetailMinuman(widget.produk as Minuman),
                  const SizedBox(height: 24),

                  // TOMBOL TAMBAH KE KERANJANG
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Tambahkan ke CartBloc
                              context.read<CartBloc>().add(
                                AddToCart(widget.produk),
                              );

                              // Tampilkan SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${widget.produk.nama} ditambahkan ke keranjang!',
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'Lihat',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );

                              // Kembali ke halaman sebelumnya
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
