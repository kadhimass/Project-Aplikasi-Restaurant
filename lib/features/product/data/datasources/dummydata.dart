import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/features/product/domain/entities/food.dart';
import 'package:menu_makanan/features/product/domain/entities/drink.dart';

class DummyData {
  static List<Produk> getProdukList() {
    return [
      Makanan(
        id: '1',
        nama: 'Nasi Goreng Spesial',
        harga: 25000,
        gambar: 'assets/images/nasi_goreng.jpg',
        deskripsi: 'Nasi goreng dengan telur, ayam, dan sosis.',
        rating: 4.5,
        bahan: ['Nasi', 'Telur', 'Ayam', 'Sosis', 'Bawang'],
      ),
      Makanan(
        id: '2',
        nama: 'Mie Goreng Jawa',
        harga: 22000,
        gambar: 'assets/images/mie_goreng.jpg',
        deskripsi: 'Mie goreng khas Jawa dengan bumbu rempah pilihan.',
        rating: 4.3,
        bahan: ['Mie', 'Sayuran', 'Ayam', 'Bumbu Jawa'],
      ),
      Minuman(
        id: '3',
        nama: 'Es Teh Manis',
        harga: 5000,
        gambar: 'assets/images/es_teh.jpg',
        deskripsi: 'Teh manis dingin segar.',
        rating: 4.0,
        bahan: ['Teh', 'Gula', 'Es Batu'],
      ),
      Minuman(
        id: '4',
        nama: 'Jus Jeruk',
        harga: 10000,
        gambar: 'assets/images/jus_jeruk.jpg',
        deskripsi: 'Jus jeruk murni tanpa gula tambahan.',
        rating: 4.7,
        bahan: ['Jeruk Segar'],
      ),
       Makanan(
        id: '5',
        nama: 'Sate Ayam',
        harga: 30000,
        gambar: 'assets/images/sate_ayam.jpg',
        deskripsi: 'Sate ayam dengan bumbu kacang yang lezat.',
        rating: 4.8,
        bahan: ['Daging Ayam', 'Bumbu Kacang', 'Kecap'],
      ),
    ];
  }
}
