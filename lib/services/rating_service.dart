import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user ratings using local storage
class RatingService {
  static const String _ratingsKey = 'user_ratings';

  /// Save user rating for a product
  Future<void> saveRating(String productId, double rating) async {
    final prefs = await SharedPreferences.getInstance();
    final ratings = await getAllRatings();
    ratings[productId] = rating;
    
    // Convert map to list of strings for storage
    final List<String> ratingsStrings = ratings.entries
        .map((e) => '${e.key}:${e.value}')
        .toList();
    
    await prefs.setStringList(_ratingsKey, ratingsStrings);
  }

  /// Get user rating for a specific product
  Future<double?> getRating(String productId) async {
    final ratings = await getAllRatings();
    return ratings[productId];
  }

  /// Get all user ratings
  Future<Map<String, double>> getAllRatings() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ratingsStrings = prefs.getStringList(_ratingsKey);
    
    if (ratingsStrings == null) return {};
    
    final Map<String, double> ratings = {};
    for (final ratingString in ratingsStrings) {
      final parts = ratingString.split(':');
      if (parts.length == 2) {
        final productId = parts[0];
        final rating = double.tryParse(parts[1]);
        if (rating != null) {
          ratings[productId] = rating;
        }
      }
    }
    
    return ratings;
  }
}
