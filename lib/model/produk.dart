


// Parent Class (Inheritance)
class Produk {
  // Properti privat (Encapsulation)
  final String _id;
  final String _nama;
  final String _deskripsi;
  final double _harga;
  final String _gambar;
  final double _rating;
  final String _linkWeb;
  final List<String> _bahan;

  Produk({
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
}

// Subclass Makanan (Inheritance)
class Makanan extends Produk {
  final bool pedas;

  Makanan({
    required super.id,
    required super.nama,
    required super.deskripsi,
    required super.harga,
    required super.gambar,
    required super.rating,
    required super.linkWeb,
    super.bahan,
    this.pedas = false, // Default value
  });

  // Polymorphism: Override getter kategori
  @override
  String get kategori => "Makanan";
}

// Subclass Minuman (Inheritance)
class Minuman extends Produk {
  final bool dingin;
  final String ukuran;

  Minuman({
    required super.id,
    required super.nama,
    required super.deskripsi,
    required super.harga,
    required super.gambar,
    required super.rating,
    required super.linkWeb,
    super.bahan,
    this.dingin = true, // Default value
    this.ukuran = "Regular", // Default value
  });

  // Polymorphism: Override getter kategori
  @override
  String get kategori => "Minuman";
}
