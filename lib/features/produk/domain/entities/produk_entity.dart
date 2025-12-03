import 'package:equatable/equatable.dart';

/// Domain Entity: Produk
/// Representasi data produk di layer domain (tidak bergantung pada external library)
class ProdukEntity extends Equatable {
  final String id;
  final String nama;
  final String deskripsi;
  final double harga;
  final String gambar;
  final double rating;
  final String linkWeb;
  final List<String> bahan;

  const ProdukEntity({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
    required this.rating,
    this.linkWeb = '',
    this.bahan = const [],
  });

  @override
  List<Object?> get props => [id, nama, deskripsi, harga, gambar, rating, linkWeb, bahan];
}
