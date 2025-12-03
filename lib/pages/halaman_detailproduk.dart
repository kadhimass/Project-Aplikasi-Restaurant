import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/model/produk.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:menu_makanan/services/rating_service.dart';
import 'package:menu_makanan/utils/responsive_breakpoints.dart';

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
          content: Text(
            'Rating berhasil disimpan: ${rating.toStringAsFixed(1)} ⭐',
          ),
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

    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final padding = ResponsiveBreakpoints.getAdaptivePadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produk.nama),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveBreakpoints.getMaxContentWidth(context),
            ),
            child: isMobile
                ? _buildMobileLayout(formatRupiah, padding)
                : _buildDesktopLayout(formatRupiah, padding),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(NumberFormat formatRupiah, double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gambar Produk
          _buildProductImage(widget.produk.gambar, 250),

          // Detail Produk
          const SizedBox(height: 16),
          Column(
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
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
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
                          try {
                            // Tambahkan ke CartBloc
                            context.read<CartBloc>().add(
                              AddToCart(widget.produk),
                            );

                            // Tampilkan SnackBar berhasil
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.produk.nama} ditambahkan ke keranjang! ✓',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );

                            // Kembali ke halaman sebelumnya setelah delay
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          } catch (e) {
                            // Handle error jika ada
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menambahkan: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(NumberFormat formatRupiah, double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Image
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildProductImage(widget.produk.gambar, 500),
            ),
          ),
          SizedBox(width: padding * 2),
          // Right: Details
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.produk.nama,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Rating
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Beri Rating:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RatingBar.builder(
                        initialRating: _userRating ?? 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 45,
                        itemPadding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          _saveUserRating(rating);
                        },
                        glow: true,
                        glowColor: Colors.amber.withOpacity(0.5),
                      ),
                      if (_userRating != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Rating Anda: ${_userRating!.toStringAsFixed(1)} ⭐',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(
                    formatRupiah.format(widget.produk.harga),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.produk.deskripsi,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),

                  // Product-specific details
                  if (widget.produk is Makanan)
                    _buildDetailMakanan(widget.produk as Makanan),
                  if (widget.produk is Minuman)
                    _buildDetailMinuman(widget.produk as Minuman),
                  const SizedBox(height: 32),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          // Tambahkan ke CartBloc
                          context.read<CartBloc>().add(
                            AddToCart(widget.produk),
                          );

                          // Tampilkan SnackBar berhasil
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.produk.nama} ditambahkan ke keranjang! ✓',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );

                          // Kembali ke halaman sebelumnya setelah delay
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          });
                        } catch (e) {
                          // Handle error jika ada
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal menambahkan: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'TAMBAH KE KERANJANG',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildProductImage(String imagePath, double height) {
    // Check if it's a network URL or local asset
    final isNetworkImage = imagePath.startsWith('http');

    if (isNetworkImage) {
      // Display network image
      return Image.network(
        imagePath,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.fastfood, color: Colors.grey, size: 64),
          );
        },
      );
    } else {
      // Display asset image
      return Image.asset(
        imagePath,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.fastfood, color: Colors.grey, size: 64),
          );
        },
      );
    }
  }
}
