import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:menu_makanan/halaman_detailproduk.dart';
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
    final currencyFormatter = NumberFormat.currency(
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
                return _buildMobileVerticalScroll(produkList, currencyFormatter, context);
              } else {
                // DESKTOP/TABLET: Grid traditional
                return _buildDesktopLayout(produkList, currencyFormatter, context, screenWidth);
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
    BuildContext context
  ) {
    // Bagi produk menjadi chunks berisi 5 item per baris
    List<List<Produk>> rows = [];
    for (int i = 0; i < produkList.length; i += 5) {
      int end = (i + 5 < produkList.length) ? i + 5 : produkList.length;
      rows.add(produkList.sublist(i, end));
    }

    return Column(
      children: [
        // Swipe indicator untuk baris horizontal
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            /*children: [
              Icon(Icons.swipe_rounded, color: Colors.orange, size: 16),
              SizedBox(width: 6),
              Text(
                'Setiap baris berisi 5 menu - Geser horizontal',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],*/
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: rows.length,
            itemBuilder: (context, rowIndex) {
              return Container(
                height: 170, // Tinggi tetap untuk setiap baris
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildProductRow(rows[rowIndex], currencyFormatter, context, rowIndex),
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
    int rowIndex
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional: Row label (misal: "Menu Populer", "Rekomendasi", dll)
        /*if (rowIndex == 0) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'Menu Populer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ] else if (rowIndex == 1) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'Rekomendasi Hari Ini',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],*/
        
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 5, // Selalu 5 kolom per baris
            itemBuilder: (context, index) {
              if (index < rowProducts.length) {
                final produk = rowProducts[index];
                return Container(
                  width: MediaQuery.of(context).size.width / 3.5, // Lebar responsive
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildMobileProductCard(produk, currencyFormatter, context),
                );
              } else {
                // Placeholder untuk kolom kosong (jika kurang dari 5 produk di baris terakhir)
                return Container(
                  width: MediaQuery.of(context).size.width / 3.5,
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
                            Icon(Icons.fastfood, color: Colors.grey.shade400, size: 40),
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
    BuildContext context
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanDetail(
              produk: produk,
              onTambahKeKeranjang: () {
                onAddToCart(produk);
              },
            ),
          ),
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
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
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
                    
                    // Harga
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
                      height: 24,
                      child: ElevatedButton(
                        onPressed: () {
                          onAddToCart(produk);
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
                            Text(
                              'Pesan',
                              style: TextStyle(fontSize: 9),
                            ),
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
    double screenWidth
  ) {
    final crossAxisCount = screenWidth < 1000 ? 3 : 4;
    
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: produkList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: crossAxisCount == 3 ? 0.7 : 0.65,
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
    BuildContext context
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanDetail(
              produk: produk,
              onTambahKeKeranjang: () {
                onAddToCart(produk);
              },
            ),
          ),
        );
      },
      child: GFCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        elevation: 3,
        boxFit: BoxFit.cover,
        showImage: true,
        image: Image.asset(
          produk.gambar,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        title: GFListTile(
          padding: const EdgeInsets.all(8),
          title: Text(
            produk.nama,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subTitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              currencyFormatter.format(produk.harga),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        buttonBar: GFButtonBar(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            GFButton(
              onPressed: () {
                onAddToCart(produk);
              },
              text: 'Pesan',
              icon: const Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
                size: 18,
              ),
              color: Colors.orange,
              fullWidthButton: true,
            ),
          ],
        ),
      ),
    );
  }
}