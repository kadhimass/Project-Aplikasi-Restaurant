import 'package:menu_makanan/features/cart/domain/entities/cart.dart';

class TransaksiEntity {
  final String idTransaksi;
  final Cart cart;
  final String email;
  final DateTime waktuTransaksi;

  const TransaksiEntity({
    required this.idTransaksi,
    required this.cart,
    required this.email,
    required this.waktuTransaksi,
  });

  double get totalSebelumDiskon => cart.totalHarga;
  double get jumlahDiskon => cart.jumlahDiskon;
  double get totalSetelahDiskon => cart.hargaSetelahDiskon;
  bool get dapatDiskon => cart.dapatDiskon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransaksiEntity &&
          runtimeType == other.runtimeType &&
          idTransaksi == other.idTransaksi &&
          cart == other.cart &&
          email == other.email &&
          waktuTransaksi == other.waktuTransaksi;

  @override
  int get hashCode =>
      idTransaksi.hashCode ^
      cart.hashCode ^
      email.hashCode ^
      waktuTransaksi.hashCode;
}
