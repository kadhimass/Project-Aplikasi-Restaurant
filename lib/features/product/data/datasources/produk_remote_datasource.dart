import 'package:dio/dio.dart';
import 'package:menu_makanan/core/errors/exceptions.dart';
import 'package:menu_makanan/features/product/data/models/produk_model.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';

abstract class ProdukRemoteDataSource {
  Future<List<ProdukModel>> searchProduk(String query);
  Future<List<ProdukModel>> getMinuman();
  Future<List<ProdukModel>> searchMinuman(String query);
}

class ProdukRemoteDataSourceImpl implements ProdukRemoteDataSource {
  final Dio dio;

  ProdukRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProdukModel>> searchProduk(String query) async {
    if (query.isNotEmpty) {
      final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> meals = response.data['meals'] ?? [];
        return meals.map((meal) => ProdukModel.fromMealDBJson(meal)).toList();
      } else {
        throw ServerException();
      }
    } else {
      // Fetch default (s=) and additional (f=b for Beef, f=c for Chicken)
      final url1 = 'https://www.themealdb.com/api/json/v1/1/search.php?s=';
      final url2 = 'https://www.themealdb.com/api/json/v1/1/search.php?f=b'; // Beef
      final url3 = 'https://www.themealdb.com/api/json/v1/1/search.php?f=c'; // Chicken

      try {
        final responses = await Future.wait([
          dio.get(url1),
          dio.get(url2),
          dio.get(url3),
        ]);

        final List<ProdukModel> allMeals = [];
        final Set<String> existingIds = {};

        for (var response in responses) {
          if (response.statusCode == 200) {
            final List<dynamic> meals = response.data['meals'] ?? [];
            for (var mealJson in meals) {
              final meal = ProdukModel.fromMealDBJson(mealJson);
              if (!existingIds.contains(meal.id)) {
                existingIds.add(meal.id);
                allMeals.add(meal);
              }
            }
          }
        }
        return allMeals;
      } catch (e) {
        throw ServerException();
      }
    }
  }

  @override
  Future<List<ProdukModel>> getMinuman() async {
    // Search for all drinks (s=) and maybe some specific letters to get variety
    final url1 = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=';
    final url2 = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a';

    try {
      final responses = await Future.wait([
        dio.get(url1),
        dio.get(url2),
      ]);

      final List<ProdukModel> allDrinks = [];
      final Set<String> existingIds = {};

      for (var response in responses) {
        if (response.statusCode == 200) {
          final drinksData = response.data['drinks'];
          if (drinksData is List) {
            for (var drinkJson in drinksData) {
              final drink = ProdukModel.fromCocktailDBJson(drinkJson);
              if (!existingIds.contains(drink.id)) {
                existingIds.add(drink.id);
                allDrinks.add(drink);
              }
            }
          }
        }
      }
      return allDrinks;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ProdukModel>> searchMinuman(String query) async {
    final url = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query';
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final drinksData = response.data['drinks'];
      if (drinksData is List) {
        return drinksData.map((drink) => ProdukModel.fromCocktailDBJson(drink)).toList();
      } else {
        return [];
      }
    } else {
      throw ServerException();
    }
  }
}
