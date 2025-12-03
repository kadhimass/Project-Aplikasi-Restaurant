import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/features/produk/domain/entities/produk_entity.dart';
import 'package:menu_makanan/features/produk/presentation/cubit/produk_cubit.dart';
import 'package:menu_makanan/features/produk/presentation/bloc/produk_state.dart';
import 'package:menu_makanan/model/produk.dart';

class ProdukListPage extends StatefulWidget {
  final String email;

  const ProdukListPage({super.key, required this.email});

  @override
  State<ProdukListPage> createState() => _ProdukListPageState();
}

class _ProdukListPageState extends State<ProdukListPage> {
  final TextEditingController _searchController = TextEditingController();
  ProdukCategory _selectedCategory = ProdukCategory.makanan;

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<ProdukCubit>().getProduk(category: _selectedCategory);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<ProdukCubit>().getProduk(category: _selectedCategory);
    } else {
      context.read<ProdukCubit>().searchProduk(query, category: _selectedCategory);
    }
  }

  void _onCategoryChanged(bool selected, ProdukCategory category) {
    if (selected) {
      setState(() {
        _selectedCategory = category;
        _searchController.clear();
      });
      context.read<ProdukCubit>().getProduk(category: category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Column(
      children: [
        // Banner promo
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.orange.shade100,
          child: Row(
            children: [
              const Icon(Icons.local_offer, color: Colors.orange),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Diskon Rp 10.000 untuk pesanan di atas Rp 50.000',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),

        // Search Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari produk...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),

        // Filter Category and Sort
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Makanan'),
                selected: _selectedCategory == ProdukCategory.makanan,
                onSelected: (selected) =>
                    _onCategoryChanged(selected, ProdukCategory.makanan),
                selectedColor: Colors.orange,
                labelStyle: TextStyle(
                  color: _selectedCategory == ProdukCategory.makanan
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Minuman'),
                selected: _selectedCategory == ProdukCategory.minuman,
                onSelected: (selected) =>
                    _onCategoryChanged(selected, ProdukCategory.minuman),
                selectedColor: Colors.orange,
                labelStyle: TextStyle(
                  color: _selectedCategory == ProdukCategory.minuman
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const Spacer(),
              PopupMenuButton<bool?>(
                icon: const Icon(Icons.sort),
                onSelected: (bool? ascending) {
                  context.read<ProdukCubit>().sortProduk(ascending: ascending);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<bool?>>[
                  const PopupMenuItem<bool?>(
                    value: null,
                    child: Row(
                      children: [
                        Icon(Icons.restore, size: 16),
                        SizedBox(width: 8),
                        Text('Default'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<bool?>(
                    value: true,
                    child: Row(
                      children: [
                        Icon(Icons.arrow_upward, size: 16),
                        SizedBox(width: 8),
                        Text('Harga Terendah'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<bool?>(
                    value: false,
                    child: Row(
                      children: [
                        Icon(Icons.arrow_downward, size: 16),
                        SizedBox(width: 8),
                        Text('Harga Tertinggi'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Daftar produk dari API via Cubit
        Expanded(
          child: BlocBuilder<ProdukCubit, ProdukState>(
            builder: (context, state) {
              if (state is ProdukLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProdukError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is ProdukLoaded) {
                final produkList = state.produkList;
                final sortOrder = state.sortOrder;
                
                if (produkList.isEmpty) {
                  return const Center(child: Text('Tidak ada produk ditemukan'));
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final isMobile = screenWidth < 600;

                    if (isMobile) {
                      return _buildMobileVerticalScroll(
                        produkList,
                        formatRupiah,
                        context,
                        sortOrder,
                      );
                    } else {
                      return _buildDesktopLayout(
                        produkList,
                        formatRupiah,
                        context,
                        screenWidth,
                        sortOrder,
                      );
                    }
                  },
                );
              }
              return const Center(child: Text('Mulai pencarian...'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileVerticalScroll(
    List<ProdukEntity> produkList,
    NumberFormat currencyFormatter,
    BuildContext context,
    SortOrder sortOrder,
  ) {
    return GridView.builder(
      key: ValueKey('grid_$sortOrder'),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: produkList.length,
      itemBuilder: (context, index) {
        return _buildMobileProductCard(
          produkList[index],
          currencyFormatter,
          context,
        );
      },
    );
  }

  Widget _buildMobileProductCard(
    ProdukEntity produk,
    NumberFormat currencyFormatter,
    BuildContext context,
  ) {
    // Convert Entity to Model for Cart/Detail compatibility
    Produk produkModel;

    if (_selectedCategory == ProdukCategory.makanan) {
      produkModel = Makanan(
        id: produk.id,
        nama: produk.nama,
        deskripsi: produk.deskripsi,
        harga: produk.harga,
        gambar: produk.gambar,
        rating: produk.rating,
        linkWeb: produk.linkWeb,
        bahan: produk.bahan,
      );
    } else {
      produkModel = Minuman(
        id: produk.id,
        nama: produk.nama,
        deskripsi: produk.deskripsi,
        harga: produk.harga,
        gambar: produk.gambar,
        rating: produk.rating,
        linkWeb: produk.linkWeb,
        bahan: produk.bahan,
      );
    }

    return InkWell(
      onTap: () {
        context.pushNamed(
          'detail',
          extra: {
            'produk': produkModel,
          },
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(produk.gambar),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
                ),
                child: produk.gambar.isEmpty
                    ? const Icon(Icons.fastfood, size: 50, color: Colors.grey)
                    : null,
              ),
            ),

            // Info produk
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(produk.harga),
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(AddToCart(produkModel));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Pesan', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    List<ProdukEntity> produkList,
    NumberFormat currencyFormatter,
    BuildContext context,
    double screenWidth,
    SortOrder sortOrder,
  ) {
    final crossAxisCount = screenWidth < 800 ? 3 : (screenWidth < 1200 ? 4 : 6);

    return GridView.builder(
      key: ValueKey('desktop_grid_$sortOrder'),
      padding: const EdgeInsets.all(12),
      itemCount: produkList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final produk = produkList[index];
        Produk produkModel;

        if (_selectedCategory == ProdukCategory.makanan) {
          produkModel = Makanan(
            id: produk.id,
            nama: produk.nama,
            deskripsi: produk.deskripsi,
            harga: produk.harga,
            gambar: produk.gambar,
            rating: produk.rating,
            linkWeb: produk.linkWeb,
            bahan: produk.bahan,
          );
        } else {
          produkModel = Minuman(
            id: produk.id,
            nama: produk.nama,
            deskripsi: produk.deskripsi,
            harga: produk.harga,
            gambar: produk.gambar,
            rating: produk.rating,
            linkWeb: produk.linkWeb,
            bahan: produk.bahan,
          );
        }

        return _buildDesktopProductCard(produkModel, currencyFormatter, context);
      },
    );
  }

  Widget _buildDesktopProductCard(
    Produk produk,
    NumberFormat currencyFormatter,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        context.pushNamed('detail', extra: {'produk': produk});
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
                child: Image.network(
                  produk.gambar,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(produk.harga),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.read<CartBloc>().add(AddToCart(produk)),
                  icon: const Icon(Icons.add_shopping_cart, size: 16),
                  label: const Text('Pesan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
