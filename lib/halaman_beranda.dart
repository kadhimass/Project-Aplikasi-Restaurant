import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:menu_makanan/bloc/cart_bloc.dart';
import 'package:menu_makanan/bloc/cart_event.dart';
import 'package:menu_makanan/bloc/cart_state.dart';
import 'package:menu_makanan/halaman_detailproduk.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_makanan/model/dummydata.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/produk.dart';

class HalamanBeranda extends StatelessWidget {
  final Keranjang keranjang;
  final String email;
  final Function(Produk) onAddToCart;

  const HalamanBeranda({
    super.key,
    required this.keranjang,
    required this.email,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    List<Produk> produkList = DummyData.getProdukList();
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Column(
      children: [
        // Banner promo
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.orange.shade100,
          child: const Row(
            children: [
              Icon(Icons.local_offer, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Diskon Rp 10.000 untuk pesanan di atas Rp 50.000',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),

        // Daftar produk dengan layout responsif
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isMobile = screenWidth < 600;

              if (isMobile) {
                // MOBILE: Setiap baris 5 kolom, scroll vertikal untuk baris berikutnya
                return _buildMobileVerticalScroll(
                  produkList,
                  formatRupiah,
                  context,
                );
              } else {
                // DESKTOP/TABLET: Grid traditional
                return _buildDesktopLayout(
                  produkList,
                  formatRupiah,
                  context,
                  screenWidth,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  // Layout mobile: Setiap baris 5 kolom, scroll vertikal
  Widget _buildMobileVerticalScroll(
    List<Produk> produkList,
    NumberFormat currencyFormatter,
    BuildContext context,
  ) {
    // Bagi produk menjadi chunks berisi 5 item per baris
    List<List<Produk>> rows = [];
    for (int i = 0; i < produkList.length; i += 5) {
      int end = (i + 5 < produkList.length) ? i + 5 : produkList.length;
      rows.add(produkList.sublist(i, end));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: rows.length,
            itemBuilder: (context, rowIndex) {
              return Container(
                height: 24.h, // Tinggi responsif untuk setiap baris (sizer)
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildProductRow(
                  rows[rowIndex],
                  currencyFormatter,
                  context,
                  rowIndex,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget untuk membangun satu baris berisi 5 produk
  Widget _buildProductRow(
    List<Produk> rowProducts,
    NumberFormat currencyFormatter,
    BuildContext context,
    int rowIndex,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 5, // Selalu 5 kolom per baris
            itemBuilder: (context, index) {
              if (index < rowProducts.length) {
                final produk = rowProducts[index];
                return Container(
                  width: 40.w, // Lebar responsif menggunakan sizer
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildMobileProductCard(
                    produk,
                    currencyFormatter,
                    context,
                  ),
                );
              } else {
                // Placeholder untuk kolom kosong (jika kurang dari 5 produk di baris terakhir)
                return Container(
                  width: 40.w,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Opacity(
                    opacity: 0.3,
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fastfood,
                              color: Colors.grey.shade400,
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Segera Hadir',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  // Card produk untuk mobile (compact)
  Widget _buildMobileProductCard(
    Produk produk,
    NumberFormat currencyFormatter,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'detail',
          extra: {'produk': produk, 'onTambah': () => onAddToCart(produk)},
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            Container(
              height: 12.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage(produk.gambar),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Info produk
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nama produk
                    Text(
                      produk.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Harga produk
                    Text(
                      currencyFormatter.format(produk.harga),
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    // Tombol pesan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartBloc>().add(AddToCart(produk));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_shopping_cart, size: 10),
                            SizedBox(width: 2),
                            Text('Pesan', style: TextStyle(fontSize: 9)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Layout untuk desktop/tablet (grid traditional)
  Widget _buildDesktopLayout(
    List<Produk> produkList,
    NumberFormat currencyFormatter,
    BuildContext context,
    double screenWidth,
  ) {
    // Hitung jumlah kolom berdasarkan lebar layar agar responsif
    final crossAxisCount = screenWidth < 800 ? 3 : (screenWidth < 1200 ? 4 : 6);

    // Perkirakan lebar tile setelah memperhitungkan padding dan spacing
    const horizontalPadding = 12.0; // padding GridView
    const spacing = 12.0; // crossAxisSpacing
    final totalSpacing = (crossAxisCount - 1) * spacing + 2 * horizontalPadding;
    final tileWidth = (screenWidth - totalSpacing) / crossAxisCount;

    // Tetapkan tinggi target tile agar konten (image + title + button) muat
    final tileHeight = 40.h; // tinggi tile responsif menggunakan sizer

    return GridView.builder(
      padding: const EdgeInsets.all(horizontalPadding),
      itemCount: produkList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        // Gunakan rasio lebar:tinggi yang dihitung agar tile tidak terpotong
        childAspectRatio: tileWidth / tileHeight,
      ),
      itemBuilder: (context, index) {
        final produk = produkList[index];
        return _buildDesktopProductCard(produk, currencyFormatter, context);
      },
    );
  }

  // Card produk untuk desktop (original GFCard)
  Widget _buildDesktopProductCard(
    Produk produk,
    NumberFormat currencyFormatter,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'detail',
          extra: {'produk': produk, 'onTambah': () => onAddToCart(produk)},
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image area: gunakan Expanded supaya gambar mengambil sisa ruang yang tersedia
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
                child: Image.asset(
                  produk.gambar,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Title + price
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(produk.harga),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Button area: gunakan height tetap kecil sehingga tidak memaksa layout
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SizedBox(
                height: 5.h,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.read<CartBloc>().add(AddToCart(produk)),
                  icon: const Icon(Icons.add_shopping_cart, size: 16),
                  label: const Text('Pesan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
