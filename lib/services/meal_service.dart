import 'package:dio/dio.dart';

/// Service menggunakan Dio untuk memanggil TheMealDB API.
/// TheMealDB adalah public API yang menyediakan data meal/makanan.
class MealService {
  // TheMealDB API key - kunci publik untuk akses API
  static const String _apiKey = '1';

  // Konfigurasi Dio untuk TheMealDB API
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.themealdb.com/api/json/v1/$_apiKey',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 5000),
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  /// Ambil semua meal dari TheMealDB API.
  /// Endpoint: /search.php?s (mencari semua meal)
  ///
  /// Mengembalikan list meal atau melempar Exception jika gagal.
  static Future<List<dynamic>> fetchSemuaMeal() async {
    try {
      // Cari meals tanpa filter (s parameter kosong untuk mendapat list)
      // Atau bisa gunakan /latest.php untuk 10 meal terbaru
      final response = await _dio.get('/latest.php');

      // Dio biasanya mengembalikan statusCode di response.statusCode
      if (response.statusCode == 200) {
        final data = response.data;

        // TheMealDB mengembalikan {meals: [...]} atau kadang meals: null
        if (data is Map && data.containsKey('meals')) {
          final mealsRaw = data['meals'];
          if (mealsRaw == null) return <dynamic>[]; // no meals
          // mealsRaw bisa berupa List atau Map (safety)
          if (mealsRaw is List) return mealsRaw;
          if (mealsRaw is Map) return [mealsRaw];
        }
        // Jika format tidak sesuai, kembalikan list kosong daripada melempar
        return <dynamic>[];
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Tangani error Dio dengan lebih baik
      String message = e.message ?? e.toString();
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        message = 'Connection timed out';
      } else if (e.type == DioExceptionType.badResponse) {
        message = 'Server responded with status ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.cancel) {
        message = 'Request was cancelled';
      }
      throw Exception('Failed to fetch meals: $message');
    } catch (e) {
      throw Exception('Failed to fetch meals: $e');
    }
  }

  /// Cari meal berdasarkan nama
  static Future<List<dynamic>> searchByName(String mealName) async {
    try {
      final response = await _dio.get(
        '/search.php',
        queryParameters: {'s': mealName},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('meals')) {
          final mealsRaw = data['meals'];
          if (mealsRaw == null) return <dynamic>[];
          if (mealsRaw is List) return mealsRaw;
          if (mealsRaw is Map) return [mealsRaw];
        }
        return <dynamic>[];
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } on DioException catch (e) {
      String message = e.message ?? e.toString();
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        message = 'Connection timed out';
      } else if (e.type == DioExceptionType.badResponse) {
        message = 'Server responded with status ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.cancel) {
        message = 'Request was cancelled';
      }
      throw Exception('Failed to search meals: $message');
    } catch (e) {
      throw Exception('Failed to search meals: $e');
    }
  }

  /// Cari meal berdasarkan ingredient
  static Future<List<dynamic>> searchByIngredient(String ingredient) async {
    try {
      final response = await _dio.get(
        '/filter.php',
        queryParameters: {'i': ingredient},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('meals')) {
          final mealsRaw = data['meals'];
          if (mealsRaw == null) return <dynamic>[];
          if (mealsRaw is List) return mealsRaw;
          if (mealsRaw is Map) return [mealsRaw];
        }
        return <dynamic>[];
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } on DioException catch (e) {
      String message = e.message ?? e.toString();
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        message = 'Connection timed out';
      } else if (e.type == DioExceptionType.badResponse) {
        message = 'Server responded with status ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.cancel) {
        message = 'Request was cancelled';
      }
      throw Exception('Failed to search by ingredient: $message');
    } catch (e) {
      throw Exception('Failed to search by ingredient: $e');
    }
  }

  /// Ambil detail meal berdasarkan ID
  /// Endpoint: /lookup.php?i={id}
  /// Mengembalikan Map meal atau null jika tidak ditemukan
  static Future<Map<String, dynamic>?> fetchMealById(String id) async {
    try {
      final response = await _dio.get(
        '/lookup.php',
        queryParameters: {'i': id},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data.containsKey('meals')) {
          final mealsRaw = data['meals'];
          if (mealsRaw == null) return null;
          if (mealsRaw is List && mealsRaw.isNotEmpty) {
            final first = mealsRaw.first;
            if (first is Map) return Map<String, dynamic>.from(first);
          }
          if (mealsRaw is Map) return Map<String, dynamic>.from(mealsRaw);
        }
        return null;
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } on DioException catch (e) {
      String message = e.message ?? e.toString();
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        message = 'Connection timed out';
      } else if (e.type == DioExceptionType.badResponse) {
        message = 'Server responded with status ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.cancel) {
        message = 'Request was cancelled';
      }
      throw Exception('Failed to fetch meal by id: $message');
    } catch (e) {
      throw Exception('Failed to fetch meal by id: $e');
    }
  }
}

