import 'package:flutter/material.dart';
import 'package:menu_makanan/services/meal_service.dart';

/// CONTOH ADVANCED: Widget dengan search dan filter
/// untuk mencari meal dari TheMealDB API

class MealSearchWidget extends StatefulWidget {
  const MealSearchWidget({super.key});

  @override
  State<MealSearchWidget> createState() => _MealSearchWidgetState();
}

class _MealSearchWidgetState extends State<MealSearchWidget> {
  late Future<List<dynamic>> _mealsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Default: fetch latest meals
    _mealsFuture = MealService.fetchSemuaMeal();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Handle search
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        // Jika kosong, tampilkan latest
        _mealsFuture = MealService.fetchSemuaMeal();
      } else {
        // Search berdasarkan nama meal
        _mealsFuture = MealService.searchByName(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: _handleSearch,
            decoration: InputDecoration(
              hintText: 'Cari meal (e.g. Pasta, Pizza)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _handleSearch('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Hasil search / meals list
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _mealsFuture,
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}'),
                    ],
                  ),
                );
              }

              // No data
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    _searchQuery.isEmpty
                        ? 'Tidak ada meal tersedia'
                        : 'Tidak ada meal yang cocok dengan "$_searchQuery"',
                  ),
                );
              }

              final meals = snapshot.data!;

              // Grid meals
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return _buildMealGridItem(context, meal);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Widget untuk grid meal item
  Widget _buildMealGridItem(BuildContext context, dynamic meal) {
    final mealName = meal['strMeal'] as String? ?? 'Unknown';
    final mealImage = meal['strMealThumb'] as String? ?? '';
    final mealCategory = meal['strCategory'] as String? ?? '';

    return Card(
      child: Stack(
        children: [
          // Gambar
          if (mealImage.isNotEmpty)
            Image.network(
              mealImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.fastfood),
                );
              },
            ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ),

          // Text content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (mealCategory.isNotEmpty)
                    Text(
                      mealCategory,
                      style: TextStyle(color: Colors.grey[300], fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CONTOH PENGGUNAAN:
// ============================================================================
//
// Buat route baru atau tambahkan di navigation:
//
// 1. Di main.dart, tambahkan import:
//    import 'package:menu_makanan/meal_search_page.dart';
//
// 2. Tambahkan route di GoRouter:
//    GoRoute(
//      path: '/meal-search',
//      builder: (context, state) => const MealSearchPage(),
//    ),
//
// 3. Akses dari button/menu:
//    context.push('/meal-search');
//
// ============================================================================
