import 'package:equatable/equatable.dart';

enum ProdukCategory { makanan, minuman }

abstract class ProdukEvent extends Equatable {
  const ProdukEvent();

  @override
  List<Object> get props => [];
}

class GetProdukEvent extends ProdukEvent {
  final ProdukCategory category;

  const GetProdukEvent({this.category = ProdukCategory.makanan});

  @override
  List<Object> get props => [category];
}

class SearchProdukEvent extends ProdukEvent {
  final String query;
  final ProdukCategory category;

  const SearchProdukEvent(this.query, {this.category = ProdukCategory.makanan});

  @override
  List<Object> get props => [query, category];
}
