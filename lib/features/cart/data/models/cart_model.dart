import 'package:menu_makanan/features/cart/domain/entities/cart.dart';
import 'package:menu_makanan/features/cart/domain/entities/cart_item.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/features/product/domain/entities/food.dart';
import 'package:menu_makanan/features/product/domain/entities/drink.dart';

class CartModel {
  final List<CartItemModel> items;

  const CartModel({this.items = const []});

  factory CartModel.fromEntity(Cart cart) {
    return CartModel(
      items: cart.items.map((item) => CartItemModel.fromEntity(item)).toList(),
    );
  }

  Cart toEntity() {
    return Cart(items: items.map((item) => item.toEntity()).toList());
  }

  CartModel copyWith({List<CartItemModel>? items}) {
    return CartModel(items: items ?? this.items);
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((item) => item.toJson()).toList()};
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
    );
  }
}

class CartItemModel {
  final Map<String, dynamic> produkJson;
  final int jumlah;

  const CartItemModel({required this.produkJson, required this.jumlah});

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      produkJson: _produkToJson(item.produk),
      jumlah: item.jumlah,
    );
  }

  CartItem toEntity() {
    return CartItem(produk: _produkFromJson(produkJson), jumlah: jumlah);
  }

  CartItemModel copyWith({Map<String, dynamic>? produkJson, int? jumlah}) {
    return CartItemModel(
      produkJson: produkJson ?? this.produkJson,
      jumlah: jumlah ?? this.jumlah,
    );
  }

  Map<String, dynamic> toJson() {
    return {'produk': produkJson, 'jumlah': jumlah};
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(produkJson: json['produk'], jumlah: json['jumlah']);
  }
}

// Helper functions to serialize/deserialize Produk
Map<String, dynamic> _produkToJson(Produk produk) {
  final json = {
    'id': produk.id,
    'nama': produk.nama,
    'deskripsi': produk.deskripsi,
    'harga': produk.harga,
    'gambar': produk.gambar,
    'rating': produk.rating,
    'linkWeb': produk.linkWeb,
    'bahan': produk.bahan,
  };

  if (produk is Makanan) {
    json['type'] = 'makanan';
  } else if (produk is Minuman) {
    json['type'] = 'minuman';
  } else {
    json['type'] = 'produk';
  }

  return json;
}

Produk _produkFromJson(Map<String, dynamic> json) {
  final type = json['type'] as String? ?? 'produk';

  if (type == 'makanan') {
    return Makanan(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      harga: (json['harga'] as num).toDouble(),
      gambar: json['gambar'],
      rating: (json['rating'] as num).toDouble(),
      linkWeb: json['linkWeb'] ?? '',
      bahan: List<String>.from(json['bahan'] ?? []),
    );
  } else if (type == 'minuman') {
    return Minuman(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      harga: (json['harga'] as num).toDouble(),
      gambar: json['gambar'],
      rating: (json['rating'] as num).toDouble(),
      linkWeb: json['linkWeb'] ?? '',
      bahan: List<String>.from(json['bahan'] ?? []),
    );
  } else {
    return Produk(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      harga: (json['harga'] as num).toDouble(),
      gambar: json['gambar'],
      rating: (json['rating'] as num).toDouble(),
      linkWeb: json['linkWeb'] ?? '',
      bahan: List<String>.from(json['bahan'] ?? []),
    );
  }
}
