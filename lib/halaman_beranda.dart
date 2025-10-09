import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart'; // <-- 1. IMPORT LIBRARY INTL
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

    // 2. BUAT OBJECT FORMATTER UNTUK MATA UANG RUPIAH
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Column(
      children: [
        // Banner promo (tidak diubah)
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.orange.shade100,
          child: const Row(
            children: [
              Icon(Icons.local_offer, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Diskon Rp 10.000 untuk pesanan di atas Rp 50.000',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Daftar produk
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: produkList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  5, // Saya kembalikan ke 2 kolom agar lebih ideal di HP
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final produk = produkList[index];
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
                        // ==========================================================
                        // 3. GUNAKAN FORMATTER PADA HARGA PRODUK
                        // ==========================================================
                        currencyFormatter.format(produk.harga),
                        // ==========================================================
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
                        text: 'Pesan', // Teks diperpendek agar muat
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 18, // Icon diperkecil
                        ),
                        color: Colors.orange,
                        fullWidthButton: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
