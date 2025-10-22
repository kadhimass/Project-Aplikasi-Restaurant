import 'package:menu_makanan/model/produk.dart';

class ItemKeranjang {
  final Produk produk;
  int jumlah;

  ItemKeranjang({
    required this.produk,
    this.jumlah = 1,
  });

  double get totalHarga => produk.harga * jumlah;
  double get hargaSetelahDiskon => totalHarga; // Placeholder jika ada diskon per item
}

class Keranjang {
  final List<ItemKeranjang> _items = [];

  Keranjang({List<ItemKeranjang>? initialItems}) {
    if (initialItems != null) {
      _items.addAll(initialItems);
    }
  }

  List<ItemKeranjang> get items => List.unmodifiable(_items);

  // Method yang sudah ada
  void tambahItem(Produk produk) {
    final existingItemIndex = _items.indexWhere((item) => item.produk.id == produk.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex] = ItemKeranjang(
        produk: _items[existingItemIndex].produk,
        jumlah: _items[existingItemIndex].jumlah + 1,
      );
    } else {
      _items.add(ItemKeranjang(produk: produk, jumlah: 1));
    }
  }

  void kurangiItem(Produk produk) {
    final existingItemIndex = _items.indexWhere((item) => item.produk.id == produk.id);
    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].jumlah > 1) {
        _items[existingItemIndex] = ItemKeranjang(
          produk: _items[existingItemIndex].produk,
          jumlah: _items[existingItemIndex].jumlah - 1,
        );
      } else {
        _items.removeAt(existingItemIndex);
      }
    }
  }

  void hapusItem(Produk produk) {
    _items.removeWhere((item) => item.produk.id == produk.id);
  }

  void kosongkan() {
    _items.clear();
  }

  int get totalItem {
    return _items.fold(0, (sum, item) => sum + item.jumlah);
  }

  // TOTAL HARGA SEBELUM DISKON
  double get totalHarga {
    return _items.fold(0, (sum, item) => sum + (item.produk.harga * item.jumlah));
  }

  // CEK APAKAH DAPAT DISKON (Total > 10.000)
  bool get dapatDiskon => totalHarga > 50000;

  // JUMLAH DISKON YANG DIDAPAT
  double get jumlahDiskon => dapatDiskon ? 10000 : 0;

  // HARGA SETELAH DISKON
  double get hargaSetelahDiskon {
    double total = totalHarga;
    if (dapatDiskon) {
      total -= jumlahDiskon;
    }
    return total < 0 ? 0 : total; // Pastikan tidak minus
  }

  // GETTER UNTUK KOMPATIBILITAS (jika ada kode yang masih menggunakan hargaDiskon)
  double? get hargaDiskon => hargaSetelahDiskon;
}