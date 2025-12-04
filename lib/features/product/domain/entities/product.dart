


import 'package:equatable/equatable.dart';

// Parent Class (Inheritance)
class Produk extends Equatable {
  // Properti privat (Encapsulation)
  final String _id;
  final String _nama;
  final String _deskripsi;
  final double _harga;
  final String _gambar;
  final double _rating;
  final String _linkWeb;
  final List<String> _bahan;

  const Produk({
    required String id,
    required String nama,
    required String deskripsi,
    required double harga,
    required String gambar,
    required double rating,
    required String linkWeb,
    List<String> bahan = const [],
  })  : _id = id,
        _nama = nama,
        _deskripsi = deskripsi,
        _harga = harga,
        _gambar = gambar,
        _rating = rating,
        _linkWeb = linkWeb,
        _bahan = bahan;

  // Getter publik
  String get id => _id;
  String get nama => _nama;
  String get deskripsi => _deskripsi;
  double get harga => _harga;
  String get gambar => _gambar;
  double get rating => _rating;
  String get linkWeb => _linkWeb;
  List<String> get bahan => _bahan;

  // Polymorphism: Method ini akan di-override oleh subclass
  String get kategori => "Umum";

  String tampilkanInfo() {
    return "$nama - Rp${harga.toStringAsFixed(0)} ($kategori)";
  }
  
  @override
  List<Object?> get props => [id, nama, deskripsi, harga, gambar, rating, linkWeb];
}


