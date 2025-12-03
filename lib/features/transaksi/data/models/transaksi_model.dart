import 'package:menu_makanan/features/cart/data/models/cart_model.dart';
import 'package:menu_makanan/features/transaksi/domain/entities/transaksi_entity.dart';

class TransaksiModel {
  final String idTransaksi;
  final CartModel cartModel;
  final String email;
  final DateTime waktuTransaksi;

  const TransaksiModel({
    required this.idTransaksi,
    required this.cartModel,
    required this.email,
    required this.waktuTransaksi,
  });

  factory TransaksiModel.fromEntity(TransaksiEntity entity) {
    return TransaksiModel(
      idTransaksi: entity.idTransaksi,
      cartModel: CartModel.fromEntity(entity.cart),
      email: entity.email,
      waktuTransaksi: entity.waktuTransaksi,
    );
  }

  TransaksiEntity toEntity() {
    return TransaksiEntity(
      idTransaksi: idTransaksi,
      cart: cartModel.toEntity(),
      email: email,
      waktuTransaksi: waktuTransaksi,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTransaksi': idTransaksi,
      'cart': cartModel.toJson(),
      'email': email,
      'waktuTransaksi': waktuTransaksi.toIso8601String(),
    };
  }

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      idTransaksi: json['idTransaksi'],
      cartModel: CartModel.fromJson(json['cart']),
      email: json['email'],
      waktuTransaksi: DateTime.parse(json['waktuTransaksi']),
    );
  }
}
