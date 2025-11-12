import 'package:menu_makanan/model/lokasi_penjual.dart';
import 'dart:math' as math;

// Service untuk data lokasi penjual
class LokasiPenjualService {

  static final List<LokasiPenjual> _dummyLokasiPenjual = [
    LokasiPenjual(
      id: '1',
      nama: 'Warung Kita - Pusat',
      latitude: -7.2504,
      longitude: 112.7488,
      alamat: 'Jl. Ahmad Yani No. 1, Surabaya, Jawa Timur',
      nomorTelepon: '081234567890',
      jamBuka: '10:00',
      jamTutup: '22:00',
      rating: 4.5,
      fotoUrl: 'assets/LOGO.png',
      kategoriMakanan: [
        'Nasi Goreng',
        'Mie Ayam',
        'Soto Ayam',
        'Es Teh Manis',
        'Jus Alpukat',
      ],
    ),
    LokasiPenjual(
      id: '2',
      nama: 'Warung Kita - Cabang Jemursari',
      latitude: -7.2546,
      longitude: 112.7623,
      alamat: 'Jl. Jemursari No. 45, Surabaya, Jawa Timur',
      nomorTelepon: '081298765432',
      jamBuka: '09:00',
      jamTutup: '23:00',
      rating: 4.7,
      fotoUrl: 'assets/LOGO.png',
      kategoriMakanan: ['Bakso', 'Lumpia', 'Martabak', 'Es Jeruk', 'Cendol'],
    ),
    LokasiPenjual(
      id: '3',
      nama: 'Warung Kita - Cabang Kenjeran',
      latitude: -7.2276,
      longitude: 112.7457,
      alamat: 'Jl. Kenjeran No. 78, Surabaya, Jawa Timur',
      nomorTelepon: '081345678901',
      jamBuka: '08:00',
      jamTutup: '22:00',
      rating: 4.3,
      fotoUrl: 'assets/LOGO.png',
      kategoriMakanan: [
        'Es Cendol',
        'Es Teller',
        'Es Teh Manis',
        'Matcha Latte',
      ],
    ),
    LokasiPenjual(
      id: '4',
      nama: 'Warung Kita - Cabang Tegalsari',
      latitude: -7.2394,
      longitude: 112.7334,
      alamat: 'Jl. Tegalsari No. 123, Surabaya, Jawa Timur',
      nomorTelepon: '081567890123',
      jamBuka: '10:30',
      jamTutup: '21:30',
      rating: 4.6,
      fotoUrl: 'assets/LOGO.png',
      kategoriMakanan: [
        'Rendang',
        'Sate Ayam',
        'Gado-Gado',
        'Crispy Calamari',
        'Sunrise Paradise',
      ],
    ),
    LokasiPenjual(
      id: '5',
      nama: 'Warung Kita - Cabang Genteng',
      latitude: -7.2569,
      longitude: 112.7416,
      alamat: 'Jl. Genteng Kali No. 56, Surabaya, Jawa Timur',
      nomorTelepon: '081678901234',
      jamBuka: '11:00',
      jamTutup: '23:30',
      rating: 4.4,
      fotoUrl: 'assets/LOGO.png',
      kategoriMakanan: [
        'Classic Rib-Eye Steak',
        'Panna Cotta Mangga',
        'spaghetti carbonara',
        'puding gyukaku',
        'caffe latte',
        'French fries',
      ],
    ),
  ];

  // Ambil semua lokasi penjual
  static Future<List<LokasiPenjual>> getSemuaLokasiPenjual() async {
    // Simulasi delay API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _dummyLokasiPenjual;
  }

  // Ambil lokasi penjual berdasarkan ID
  static Future<LokasiPenjual?> getLokasiPenjualById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _dummyLokasiPenjual.firstWhere((lokasi) => lokasi.id == id);
    } catch (e) {
      return null;
    }
  }

  // Cari lokasi penjual berdasarkan nama
  static Future<List<LokasiPenjual>> cariLokasiPenjualByNama(
    String nama,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dummyLokasiPenjual
        .where(
          (lokasi) => lokasi.nama.toLowerCase().contains(nama.toLowerCase()),
        )
        .toList();
  }

  // Cari lokasi penjual berdasarkan kategori makanan
  static Future<List<LokasiPenjual>> cariLokasiPenjualByKategori(
    String kategori,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dummyLokasiPenjual
        .where(
          (lokasi) => lokasi.kategoriMakanan.any(
            (k) => k.toLowerCase().contains(kategori.toLowerCase()),
          ),
        )
        .toList();
  }

  // Cari lokasi penjual berdasarkan nama menu (item dalam kategoriMakanan)
  static Future<List<LokasiPenjual>> cariLokasiPenjualByNamaMenu(
    String namaMenu,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dummyLokasiPenjual
        .where(
          (lokasi) => lokasi.kategoriMakanan.any(
            (menu) => menu.toLowerCase().contains(namaMenu.toLowerCase()),
          ),
        )
        .toList();
  }

  // Ambil lokasi penjual dalam radius tertentu (dalam km)
  // Menggunakan Haversine formula untuk menghitung jarak
  static Future<List<LokasiPenjual>> getLokasiPenjualByRadius(
    double userLatitude,
    double userLongitude,
    double radiusKm,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _dummyLokasiPenjual.where((lokasi) {
      double distance = _calculateDistance(
        userLatitude,
        userLongitude,
        lokasi.latitude,
        lokasi.longitude,
      );
      return distance <= radiusKm;
    }).toList();
  }

  // Hitung jarak antar koordinat menggunakan Haversine formula
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        (Math.sin(dLat / 2) * Math.sin(dLat / 2)) +
        (Math.cos(_degreesToRadians(lat1)) *
            Math.cos(_degreesToRadians(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2));

    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }
}

// Helper class untuk math operations
class Math {
  static double sin(double x) => math.sin(x);
  static double cos(double x) => math.cos(x);
  static double sqrt(double x) => math.sqrt(x);
  static double atan2(double y, double x) => math.atan2(y, x);
}
