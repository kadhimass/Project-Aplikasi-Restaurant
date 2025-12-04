import 'package:equatable/equatable.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';

enum SortOrder { defaultOrder, ascending, descending }

abstract class ProdukState extends Equatable {
  const ProdukState();

  @override
  List<Object> get props => [];
}

class ProdukInitial extends ProdukState {}

class ProdukLoading extends ProdukState {}

class ProdukLoaded extends ProdukState {
  final List<Produk> produkList;
  final List<Produk> originalList;
  final SortOrder sortOrder;

  const ProdukLoaded(
    this.produkList, {
    required this.originalList,
    required this.sortOrder,
  });

  @override
  List<Object> get props => [produkList, originalList, sortOrder];
}

class ProdukError extends ProdukState {
  final String message;

  const ProdukError(this.message);

  @override
  List<Object> get props => [message];
}
