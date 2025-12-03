import 'package:equatable/equatable.dart';
import 'package:menu_makanan/features/produk/domain/entities/produk_entity.dart';

enum SortOrder { defaultOrder, ascending, descending }

abstract class ProdukState extends Equatable {
  const ProdukState();

  @override
  List<Object> get props => [];
}

class ProdukInitial extends ProdukState {}

class ProdukLoading extends ProdukState {}

class ProdukLoaded extends ProdukState {
  final List<ProdukEntity> produkList;
  final List<ProdukEntity> originalList;
  final SortOrder sortOrder;

  const ProdukLoaded(
    this.produkList, {
    List<ProdukEntity>? originalList,
    this.sortOrder = SortOrder.defaultOrder,
  }) : originalList = originalList ?? produkList;

  @override
  List<Object> get props => [produkList, originalList, sortOrder];
}

class ProdukError extends ProdukState {
  final String message;

  const ProdukError(this.message);

  @override
  List<Object> get props => [message];
}
