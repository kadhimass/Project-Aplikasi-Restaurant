import 'package:dio/dio.dart';

class MealApi {
  // Update this base URL when your real API is deployed.
  static const String _baseUrl = 'http://localhost:3000';
  static final Dio _dio = Dio();

  /// Fetch all meals from the API
  static Future<List<Map<String, dynamic>>> fetchSemuaMeal() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/meals',
        options: Options(responseType: ResponseType.json),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch meals: $e');
    }
  }
}
