import 'package:flutter/material.dart';
import 'package:menu_makanan/services/meal_service.dart';

class HalamanDetailMeal extends StatefulWidget {
  final String mealId;

  const HalamanDetailMeal({super.key, required this.mealId});

  @override
  State<HalamanDetailMeal> createState() => _HalamanDetailMealState();
}

class _HalamanDetailMealState extends State<HalamanDetailMeal> {
  late Future<Map<String, dynamic>?> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = MealService.fetchMealById(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Meal'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final meal = snapshot.data;
          if (meal == null) {
            return const Center(child: Text('Detail meal tidak ditemukan'));
          }

          // Ambil fields umum
          final name = meal['strMeal'] as String? ?? 'Unknown';
          final image = meal['strMealThumb'] as String? ?? '';
          final category = meal['strCategory'] as String? ?? '';
          final area = meal['strArea'] as String? ?? '';
          final instructions = meal['strInstructions'] as String? ?? '';

          // Kumpulkan ingredients + measures
          final List<String> ingredients = [];
          for (var i = 1; i <= 20; i++) {
            final ingKey = 'strIngredient\$i';
            final measureKey = 'strMeasure\$i';
            try {
              final ing = meal[ingKey];
              final measure = meal[measureKey];
              if (ing != null) {
                final ingStr = ing.toString().trim();
                final measureStr = (measure ?? '').toString().trim();
                if (ingStr.isNotEmpty) {
                  if (measureStr.isNotEmpty) {
                    ingredients.add(
                      '\$ingStr — '
                      '\$measureStr',
                    );
                  } else {
                    ingredients.add(ingStr);
                  }
                }
              }
            } catch (_) {}
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (category.isNotEmpty) Chip(label: Text(category)),
                    const SizedBox(width: 8),
                    if (area.isNotEmpty) Chip(label: Text(area)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (ingredients.isEmpty)
                  const Text('Tidak ada bahan terdaftar')
                else
                  ...ingredients.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('• $e'),
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Instructions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  instructions,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
