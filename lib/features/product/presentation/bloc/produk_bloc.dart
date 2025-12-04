import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_makanan/features/product/presentation/bloc/produk_event.dart';
import 'package:menu_makanan/features/product/presentation/bloc/produk_state.dart';
import 'package:menu_makanan/features/product/domain/usecases/get_all_produk_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/get_all_minuman_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/search_produk_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/search_minuman_usecase.dart';

class ProdukBloc extends Bloc<ProdukEvent, ProdukState> {
  final GetAllProdukUseCase getAllProdukUseCase;
  final GetAllMinumanUseCase getAllMinumanUseCase;
  final SearchProdukUseCase searchProdukUseCase;
  final SearchMinumanUseCase searchMinumanUseCase;

  ProdukBloc({
    required this.getAllProdukUseCase,
    required this.getAllMinumanUseCase,
    required this.searchProdukUseCase,
    required this.searchMinumanUseCase,
  }) : super(ProdukInitial()) {
    on<GetProdukEvent>(_onGetProduk);
    on<SearchProdukEvent>(_onSearchProduk);
  }

  Future<void> _onGetProduk(
    GetProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    emit(ProdukLoading());
    final result = event.category == ProdukCategory.makanan
        ? await getAllProdukUseCase()
        : await getAllMinumanUseCase();

    result.fold(
      (failure) => emit(ProdukError(failure.message)),
      (produkList) => emit(ProdukLoaded(
        produkList,
        originalList: produkList,
        sortOrder: SortOrder.defaultOrder,
      )),
    );
  }

  Future<void> _onSearchProduk(
    SearchProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    emit(ProdukLoading());
    final result = event.category == ProdukCategory.makanan
        ? await searchProdukUseCase(event.query)
        : await searchMinumanUseCase(event.query);

    result.fold(
      (failure) => emit(ProdukError(failure.message)),
      (produkList) => emit(ProdukLoaded(
        produkList,
        originalList: produkList,
        sortOrder: SortOrder.defaultOrder,
      )),
    );
  }
}
