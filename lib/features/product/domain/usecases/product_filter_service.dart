import 'package:menu_makanan/features/product/domain/entities/product.dart';

/// Service untuk filter dan sort produk
/// Memisahkan business logic dari UI layer
class ProdukFilterService {
  /// Filter produk berdasarkan tipe (makanan/minuman/semua)
  static List<Produk> filterByType(List<Produk> produkList, String filterType) {
    return produkList.where((produk) {
      if (filterType == 'makanan') {
        return produk.runtimeType.toString() == 'Makanan';
      } else if (filterType == 'minuman') {
        return produk.runtimeType.toString() == 'Minuman';
      }
      return true; // 'semua'
    }).toList();
  }

  /// Filter produk berdasarkan search query
  static List<Produk> filterBySearch(List<Produk> produkList, String query) {
    if (query.isEmpty) return produkList;
    return produkList.where((produk) {
      return produk.nama.toLowerCase().contains(query.toLowerCase()) ||
          produk.deskripsi.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Sort produk berdasarkan pilihan sort option
  static List<Produk> sortProducts(List<Produk> produkList, String sortOption) {
    List<Produk> result = List.from(produkList);
    switch (sortOption) {
      case 'harga_asc':
        result.sort((a, b) => a.harga.compareTo(b.harga));
        break;
      case 'harga_desc':
        result.sort((a, b) => b.harga.compareTo(a.harga));
        break;
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'nama':
      default:
        result.sort((a, b) => a.nama.compareTo(b.nama));
        break;
    }
    return result;
  }

  /// Kombinasi filter dan sort
  static List<Produk> filterAndSort(
    List<Produk> produkList,
    String filterType,
    String searchQuery,
    String sortOption,
  ) {
    var result = filterByType(produkList, filterType);
    result = filterBySearch(result, searchQuery);
    result = sortProducts(result, sortOption);
    return result;
  }
}
