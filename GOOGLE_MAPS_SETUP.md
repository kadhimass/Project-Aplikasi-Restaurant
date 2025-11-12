# Dokumentasi Fitur Google Maps - Lokasi Penjual

## Overview
Aplikasi sekarang dilengkapi dengan fitur Google Maps untuk menampilkan lokasi semua penjual makanan ("Warung Kita") dengan informasi detail.

## File-File yang Ditambahkan

### 1. **`lib/model/lokasi_penjual.dart`**
Model data untuk lokasi penjual yang mencakup:
- `id`: Identifier unik penjual
- `nama`: Nama warung/penjual
- `latitude` & `longitude`: Koordinat lokasi
- `alamat`: Alamat lengkap
- `nomorTelepon`: Kontak penjual
- `jamBuka` & `jamTutup`: Jam operasional
- `rating`: Rating dari pelanggan
- `fotoUrl`: URL atau path gambar penjual
- `kategoriMakanan`: Daftar kategori menu yang tersedia

### 2. **`lib/services/lokasi_penjual_service.dart`**
Service untuk mengelola data lokasi penjual dengan method:
- `getSemuaLokasiPenjual()`: Ambil semua lokasi penjual
- `getLokasiPenjualById(id)`: Cari berdasarkan ID
- `cariLokasiPenjualByNama(nama)`: Cari berdasarkan nama
- `cariLokasiPenjualByKategori(kategori)`: Cari berdasarkan kategori makanan
- `getLokasiPenjualByRadius(lat, lon, radius)`: Cari berdasarkan jarak dari user

**Note**: Saat ini menggunakan dummy data. Untuk produksi, integrasikan dengan backend API Anda.

### 3. **`lib/halaman_lokasi.dart`**
Halaman utama yang menampilkan:
- **Google Maps** dengan marker untuk setiap lokasi penjual
- **Search bar** untuk mencari lokasi
- **Horizontal list** lokasi penjual di bawah peta
- **Bottom sheet** dengan detail lengkap lokasi ketika marker ditekan

**Fitur:**
- Tampilkan marker dengan info window
- Tap marker untuk menampilkan detail penjual
- Akses user location (dengan permission handling)
- Responsive design untuk mobile

## Dependencies Baru (di `pubspec.yaml`)
```yaml
google_maps_flutter: ^2.8.0    # Widget Google Maps
location: ^6.0.0               # Akses lokasi device user
http: ^1.1.0                   # HTTP requests (untuk API future)
```

## Setup Configuration

### Android (Android Studio)
1. **Aktifkan Google Maps API:**
   - Buka [Google Cloud Console](https://console.cloud.google.com/)
   - Enable "Maps SDK for Android"
   - Generate API key

2. **Tambahkan API key ke `android/app/src/main/AndroidManifest.xml`:**
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
   ```

3. **Tambahkan permission di `android/app/src/main/AndroidManifest.xml`:**
   ```xml
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   ```

### iOS (Xcode)
1. **Tambahkan API key ke `ios/Runner/Info.plist`:**
   ```xml
   <key>com.google.ios.API_KEY</key>
   <string>YOUR_GOOGLE_MAPS_API_KEY_HERE</string>
   ```

2. **Tambahkan location permissions ke `ios/Runner/Info.plist`:**
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>App ini membutuhkan akses lokasi untuk menampilkan penjual terdekat</string>
   <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
   <string>App ini membutuhkan akses lokasi untuk menampilkan penjual terdekat</string>
   ```

## Cara Menggunakan

### 1. **Akses Fitur Lokasi**
- Buka aplikasi → Tab "Pengaturan"
- Pilih menu "Lokasi Penjual"
- Atau gunakan route: `context.pushNamed('lokasi')`

### 2. **Interaksi dengan Peta**
- **Geser peta** untuk navigasi
- **Tap marker** untuk melihat detail penjual
- **Klik item di list bawah** untuk highlight lokasi
- **Search bar** untuk mencari lokasi spesifik (fitur dapat dikembangkan)

### 3. **Informasi Detail Penjual**
Bottom sheet menampilkan:
- Foto/logo penjual
- Nama dan rating ⭐
- Alamat lengkap
- Nomor telepon
- Jam operasional
- Kategori makanan
- Tombol "Navigasi ke Lokasi" (siap untuk integrasi Google Maps app)

## Data Lokasi yang Tersedia

Aplikasi sekarang mencakup 5 lokasi penjual:

| No | Nama | Koordinat | Kategori |
|---|---|---|---|
| 1 | Warung Kita - Pusat | -7.2504, 112.7488 | Nasi Goreng, Mie Ayam, Soto |
| 2 | Warung Kita - Jemursari | -7.2546, 112.7623 | Bakso, Lumpia, Martabak |
| 3 | Warung Kita - Kenjeran | -7.2276, 112.7457 | Es Cendol, Es Jeruk, Teh |
| 4 | Warung Kita - Tegalsari | -7.2394, 112.7334 | Rendang, Sate, Gado-gado |
| 5 | Warung Kita - Genteng | -7.2569, 112.7416 | Calamari, Pasta, Steak |

## Integrasi dengan Backend (Future Enhancement)

Untuk menghubungkan dengan API backend:

```dart
// Di lokasi_penjual_service.dart, ganti dummy data dengan API call:
static Future<List<LokasiPenjual>> getSemuaLokasiPenjual() async {
  final response = await http.get(
    Uri.parse('https://your-api.com/api/penjual'),
  );
  
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => LokasiPenjual.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load lokasi penjual');
  }
}
```

## Fitur Lanjutan yang Dapat Ditambahkan

1. **Navigasi Real-time**
   - Buka aplikasi Google Maps dari tombol "Navigasi ke Lokasi"
   - Tampilkan rute terpendek ke lokasi penjual

2. **Filter Pencarian**
   - Filter berdasarkan rating, jam operasional, kategori menu
   - Tampilkan penjual terdekat (sorting by distance)

3. **User Reviews & Rating**
   - Izinkan user memberikan rating dan review
   - Tampilkan review di detail penjual

4. **Favorite Locations**
   - Izinkan user menyimpan lokasi favorit
   - Quick access ke lokasi favorit

5. **Integrasi dengan Keranjang**
   - Tampilkan produk dari penjual di peta
   - Direct order dari peta

6. **Push Notifications**
   - Notify user tentang promo dari penjual terdekat
   - Notifikasi status order ready di lokasi penjual

## Troubleshooting

### Maps tidak muncul
1. Verifikasi API key sudah benar di AndroidManifest.xml
2. Pastikan GPS/Location service enabled di device/emulator
3. Check logcat untuk error messages

### Permission denied untuk location
1. Verify permission sudah di AndroidManifest.xml
2. Untuk Android 6.0+, izinkan permission di runtime settings app
3. Restart app setelah mengubah permission

### Build error
1. Jalankan `flutter clean`
2. Jalankan `flutter pub get`
3. Build ulang dengan `flutter run`

## Testing

### Test di Emulator
```bash
# Android Emulator dengan Maps
flutter run --verbose

# Untuk testing location, gunakan Android Emulator settings:
# Extended Controls → Location → Set manual location
```

### Test di Device Fisik
- Build di device dengan internet connection stabil
- Izinkan location permissions saat first launch

---

Fitur Maps sudah siap digunakan! Untuk pertanyaan atau enhancement lebih lanjut, hubungi tim development.
