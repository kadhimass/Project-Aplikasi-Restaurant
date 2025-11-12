# API Integration Guide - Lokasi Penjual

## Ringkasan
Dokumentasi ini menjelaskan cara mengintegrasikan backend API dengan fitur Google Maps untuk lokasi penjual.

---

## 1. Backend API Structure (Expected)

### Endpoint: `GET /api/penjual`
**Response Format:**
```json
[
  {
    "id": "1",
    "nama": "Warung Kita - Pusat",
    "latitude": -7.2504,
    "longitude": 112.7488,
    "alamat": "Jl. Ahmad Yani No. 1, Surabaya, Jawa Timur",
    "nomor_telepon": "081234567890",
    "jam_buka": "10:00",
    "jam_tutup": "22:00",
    "rating": 4.5,
    "foto_url": "https://your-api.com/images/logo.png",
    "kategori_makanan": ["Nasi Goreng", "Mie Ayam", "Soto Ayam"]
  },
  ...
]
```

### Endpoint: `GET /api/penjual/:id`
**Response:** Single penjual object (sama format di atas)

### Endpoint: `GET /api/penjual/search?q=nama`
**Response:** Array of penjual matching search query

### Endpoint: `GET /api/penjual/kategori/:kategori`
**Response:** Array of penjual dengan kategori spesifik

---

## 2. Update Service untuk API Integration

Edit `lib/services/lokasi_penjual_service.dart`:

```dart
import 'package:menu_makanan/model/lokasi_penjual.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

class LokasiPenjualService {
  // Ganti dengan URL backend Anda
  static const String _baseUrl = 'https://your-api.com';

  // Ambil semua lokasi penjual
  static Future<List<LokasiPenjual>> getSemuaLokasiPenjual() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/penjual'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => LokasiPenjual.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load lokasi penjual: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Ambil lokasi penjual berdasarkan ID
  static Future<LokasiPenjual?> getLokasiPenjualById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/penjual/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return LokasiPenjual.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load lokasi penjual');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Cari lokasi penjual berdasarkan nama
  static Future<List<LokasiPenjual>> cariLokasiPenjualByNama(String nama) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/penjual/search?q=$nama'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => LokasiPenjual.fromJson(item)).toList();
      } else {
        throw Exception('Failed to search lokasi penjual');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Cari lokasi penjual berdasarkan kategori makanan
  static Future<List<LokasiPenjual>> cariLokasiPenjualByKategori(
    String kategori,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/penjual/kategori/$kategori'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => LokasiPenjual.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load lokasi penjual by kategori');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Ambil lokasi penjual dalam radius tertentu
  static Future<List<LokasiPenjual>> getLokasiPenjualByRadius(
    double userLatitude,
    double userLongitude,
    double radiusKm,
  ) async {
    try {
      final lokasiList = await getSemuaLokasiPenjual();
      
      return lokasiList.where((lokasi) {
        double distance = _calculateDistance(
          userLatitude,
          userLongitude,
          lokasi.latitude,
          lokasi.longitude,
        );
        return distance <= radiusKm;
      }).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Helper methods tetap sama
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        (math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2));

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }
}
```

---

## 3. Error Handling & Caching

Untuk production, tambahkan error handling dan caching:

```dart
import 'package:shared_preferences/shared_preferences.dart';

class LokasiPenjualService {
  static const String _cacheKey = 'lokasi_penjual_cache';
  static const int _cacheExpireMinutes = 60;

  // Ambil dari cache atau API
  static Future<List<LokasiPenjual>> getSemuaLokasiPenjual({
    bool forceRefresh = false,
  }) async {
    try {
      // Cek cache dulu jika tidak force refresh
      if (!forceRefresh) {
        final cachedData = await _getFromCache();
        if (cachedData != null) {
          return cachedData;
        }
      }

      // Fetch dari API
      final response = await http.get(
        Uri.parse('$_baseUrl/api/penjual'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final lokasiList = data
            .map((item) => LokasiPenjual.fromJson(item))
            .toList();

        // Simpan ke cache
        await _saveToCache(lokasiList);

        return lokasiList;
      } else {
        throw Exception('Failed to load lokasi penjual: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Coba lagi.');
    } catch (e) {
      // Fallback ke cache jika API error
      final cachedData = await _getFromCache();
      if (cachedData != null) {
        return cachedData;
      }
      rethrow;
    }
  }

  static Future<void> _saveToCache(List<LokasiPenjual> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(
        data.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cacheKey, jsonData);
      await prefs.setInt('${_cacheKey}_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error saving cache: $e');
    }
  }

  static Future<List<LokasiPenjual>?> _getFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_cacheKey);
      final timestamp = prefs.getInt('${_cacheKey}_timestamp') ?? 0;

      if (jsonData == null) return null;

      // Cek apakah cache expired
      final now = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = now - timestamp;
      final expireMs = _cacheExpireMinutes * 60 * 1000;

      if (cacheAge > expireMs) {
        return null; // Cache expired
      }

      List<dynamic> data = jsonDecode(jsonData);
      return data.map((item) => LokasiPenjual.fromJson(item)).toList();
    } catch (e) {
      print('Error reading cache: $e');
      return null;
    }
  }
}
```

---

## 4. Update HalamanLokasi untuk Error Handling

```dart
class _HalamanLokasiState extends State<HalamanLokasi> {
  // ... existing code ...
  
  String? _errorMessage;

  Future<void> _loadLokasiPenjual() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final lokasiList = await LokasiPenjualService.getSemuaLokasiPenjual();
      
      // ... rest of loading code ...
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
      
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage ?? 'Error loading lokasi penjual'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _loadLokasiPenjual,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... existing code ...
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadLokasiPenjual,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : // ... existing map widget ...
    );
  }
}
```

---

## 5. Testing API Integration

### Unit Test
```dart
// test/services/lokasi_penjual_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:menu_makanan/services/lokasi_penjual_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('LokasiPenjualService', () {
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });

    test('getSemuaLokasiPenjual returns list of penjual', () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(
            '[{"id":"1","nama":"Test","latitude":-7.25,"longitude":112.75,"alamat":"Test","nomor_telepon":"081234567890","jam_buka":"10:00","jam_tutup":"22:00","rating":4.5,"foto_url":"test.jpg","kategori_makanan":["Test"]}]',
            200,
          ));

      // Test implementation
    });
  });
}
```

---

## 6. Environment Configuration

Buat file `.env` untuk menyimpan URL API:

```env
# .env
API_BASE_URL=https://your-api.com
API_TIMEOUT=10
```

Kemudian update service:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LokasiPenjualService {
  static final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
  // ...
}
```

---

## 7. Production Checklist

- [ ] Update `_baseUrl` dengan URL production backend
- [ ] Implement proper error handling & retry logic
- [ ] Add request timeout (10-15 detik)
- [ ] Implement caching dengan SharedPreferences
- [ ] Test dengan network yang lambat (throttling)
- [ ] Add request logging untuk debugging
- [ ] Validate API response format
- [ ] Handle different HTTP status codes
- [ ] Add authentication if needed (JWT tokens)
- [ ] Monitor API performance

---

Untuk pertanyaan lebih lanjut, hubungi tim backend/API development.
