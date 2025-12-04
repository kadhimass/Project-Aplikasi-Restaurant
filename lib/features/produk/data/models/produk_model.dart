import 'package:menu_makanan/features/produk/domain/entities/produk_entity.dart';
import 'dart:math';

/// DTO (Data Transfer Object) untuk Produk
/// Digunakan di data layer untuk konversi dari/ke JSON atau API response
class ProdukModel extends ProdukEntity {
  const ProdukModel({
    required super.id,
    required super.nama,
    required super.deskripsi,
    required super.harga,
    required super.gambar,
    required super.rating,
    super.bahan = const [],
  });

  /// Convert dari JSON ke ProdukModel
  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      harga: (json['harga'] as num?)?.toDouble() ?? 0.0,
      gambar: json['gambar'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      bahan:
          (json['bahan'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  /// Convert dari TheMealDB JSON ke ProdukModel
  factory ProdukModel.fromMealDBJson(Map<String, dynamic> json) {
    // Parse ingredients and measures
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        String item = ingredient.toString().trim();
        if (measure != null && measure.toString().trim().isNotEmpty) {
          item = '$measure $item';
        }
        ingredients.add(item);
      }
    }

    return ProdukModel(
      id: json['idMeal'] ?? '',
      nama: json['strMeal'] ?? 'Unknown Meal',
      deskripsi: json['strInstructions'] ?? 'No description available.',
      harga: _generatePrice(json['idMeal'] ?? '0', 50000, 500000),
      gambar: json['strMealThumb'] ?? '',
      rating: 4.5, // Default rating
      bahan: ingredients,
    );
  }

  /// Convert dari TheCocktailDB JSON ke ProdukModel
  factory ProdukModel.fromCocktailDBJson(Map<String, dynamic> json) {
    // Parse ingredients and measures
    List<String> ingredients = [];
    for (int i = 1; i <= 15; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        String item = ingredient.toString().trim();
        if (measure != null && measure.toString().trim().isNotEmpty) {
          item = '$measure $item';
        }
        ingredients.add(item);
      }
    }

    return ProdukModel(
      id: json['idDrink'] ?? '',
      nama: json['strDrink'] ?? 'Unknown Drink',
      deskripsi: json['strInstructions'] ?? 'No description available.',
      harga: _generatePrice(json['idDrink'] ?? '0', 50000, 200000),
      gambar: json['strDrinkThumb'] ?? '',
      rating: 4.8, // Default rating
      bahan: ingredients,
    );
  }

  /// Generate consistent pseudo-random price based on ID
  static double _generatePrice(String id, int min, int max) {
    try {
      // Use hashCode as seed for Random to ensure consistency for the same ID
      // but variety across different IDs.
      final Random random = Random(id.hashCode);
      final int range = max - min;

      final int randomValue = random.nextInt(range);
      final int rawPrice = randomValue + min;

      // Round to nearest 1000 for cleaner prices
      return (rawPrice / 1000).round() * 1000.0;
    } catch (e) {
      return min.toDouble();
    }
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'harga': harga,
      'gambar': gambar,
      'rating': rating,
      'bahan': bahan,
    };
  }
}
