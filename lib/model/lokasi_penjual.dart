import 'package:google_maps_flutter/google_maps_flutter.dart';

class LokasiPenjual {
  final String id;
  final String nama;
  final double latitude;
  final double longitude;
  final String alamat;
  final String nomorTelepon;
  final String jamBuka;
  final String jamTutup;
  final double rating;
  final String fotoUrl;
  final List<String> kategoriMakanan;

  LokasiPenjual({
    required this.id,
    required this.nama,
    required this.latitude,
    required this.longitude,
    required this.alamat,
    required this.nomorTelepon,
    required this.jamBuka,
    required this.jamTutup,
    required this.rating,
    required this.fotoUrl,
    required this.kategoriMakanan,
  });

  // Convert to LatLng untuk Google Maps
  LatLng get latLng => LatLng(latitude, longitude);

  // Buat dari JSON
  factory LokasiPenjual.fromJson(Map<String, dynamic> json) {
    return LokasiPenjual(
      id: json['id'] as String,
      nama: json['nama'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      alamat: json['alamat'] as String,
      nomorTelepon: json['nomor_telepon'] as String,
      jamBuka: json['jam_buka'] as String,
      jamTutup: json['jam_tutup'] as String,
      rating: (json['rating'] as num).toDouble(),
      fotoUrl: json['foto_url'] as String,
      kategoriMakanan: List<String>.from(json['kategori_makanan'] as List),
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'latitude': latitude,
      'longitude': longitude,
      'alamat': alamat,
      'nomor_telepon': nomorTelepon,
      'jam_buka': jamBuka,
      'jam_tutup': jamTutup,
      'rating': rating,
      'foto_url': fotoUrl,
      'kategori_makanan': kategoriMakanan,
    };
  }
}
