

class Produk {
  // Properti privat (diawali dengan _)
  final String _id;
  final String _nama;
  final String _deskripsi;
  final double _harga;
  final String _gambar;
  final double _rating;
  final String _linkWeb;


  // Konstruktor tetap sama, namun menginisialisasi properti privat
  Produk({
    required String id,
    required String nama,
    required String deskripsi,
    required double harga,
    required String gambar,
    required double rating,
    required String linkWeb,
  })  : _id = id,
        _nama = nama,
        _deskripsi = deskripsi,
        _harga = harga,
        _gambar = gambar,
        _rating = rating,
        _linkWeb = linkWeb;

  // Getter publik untuk mengakses properti privat (Enkapsulasi)
  String get id => _id;
  String get nama => _nama;
  String get deskripsi => _deskripsi;
  double get harga => _harga;
  String get gambar => _gambar;
  double get rating => _rating;
  String get linkWeb => _linkWeb;


  // Method untuk menampilkan info produk (akan di-override oleh subclass)
  String tampilkanInfo() {
    // Menggunakan getter atau properti privat secara langsung
    return "$nama - Rp${harga.toStringAsFixed(0)}";
  }
}
