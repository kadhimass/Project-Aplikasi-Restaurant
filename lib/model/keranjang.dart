import 'package:menu_makanan/model/produk.dart';

class ItemKeranjang {
  final Produk produk;
  int jumlah;

  ItemKeranjang({
    required this.produk,
    this.jumlah = 1,
  });

  double get totalHarga => produk.harga * jumlah;
  double get hargaDiskon {
    if (totalHarga > 50000) {
      return totalHarga - 10000;
    }
    return totalHarga;
  }
}

class Keranjang {
  final List<ItemKeranjang> _items;

  Keranjang({List<ItemKeranjang>? initialItems}) : _items = initialItems ?? [];

  List<ItemKeranjang> get items => List.unmodifiable(_items);

  void tambahItem(Produk produk) {
    final index = _items.indexWhere((item) => item.produk.id == produk.id);
    if (index >= 0) {
      _items[index].jumlah++;
    } else {
      _items.add(ItemKeranjang(produk: produk));
    }
  }

  void kurangiItem(Produk produk) {
    final index = _items.indexWhere((item) => item.produk.id == produk.id);
    if (index >= 0) {
      if (_items[index].jumlah > 1) {
        _items[index].jumlah--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  void hapusItem(Produk produk) {
    _items.removeWhere((item) => item.produk.id == produk.id);
  }

  double get totalHarga {
    return _items.fold(0, (total, item) => total + item.totalHarga);
  }

  int get totalItem {
    return _items.fold(0, (total, item) => total + item.jumlah);
  }

  double? get hargaDiskon => _items.fold(0, (total, item) => total! + item.hargaDiskon);

  void kosongkan() {
    _items.clear();
  }
}