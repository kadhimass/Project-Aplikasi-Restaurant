import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/features/product/domain/usecases/get_all_produk_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/search_produk_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/get_minuman_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/search_minuman_usecase.dart';
import 'package:menu_makanan/features/product/presentation/bloc/produk_state.dart';

enum ProdukCategory { makanan, minuman }

class ProdukCubit extends Cubit<ProdukState> {
  final GetAllProdukUseCase getAllProdukUseCase;
  final SearchProdukUseCase searchProdukUseCase;
  final GetMinumanUseCase getMinumanUseCase;
  final SearchMinumanUseCase searchMinumanUseCase;

  ProdukCubit({
    required this.getAllProdukUseCase,
    required this.searchProdukUseCase,
    required this.getMinumanUseCase,
    required this.searchMinumanUseCase,
  }) : super(ProdukInitial());

  Future<void> getProduk({ProdukCategory category = ProdukCategory.makanan}) async {
    emit(ProdukLoading());
    
    final result = category == ProdukCategory.makanan
        ? await getAllProdukUseCase()
        : await getMinumanUseCase();

    result.fold(
      (failure) => emit(ProdukError(failure.message)),
      (produkList) => emit(ProdukLoaded(
        produkList,
        originalList: produkList,
        sortOrder: SortOrder.defaultOrder,
      )),
    );
  }

  Future<void> searchProduk(String query, {ProdukCategory category = ProdukCategory.makanan}) async {
    emit(ProdukLoading());

    final result = category == ProdukCategory.makanan
        ? await searchProdukUseCase(query)
        : await searchMinumanUseCase(query);

    result.fold(
      (failure) => emit(ProdukError(failure.message)),
      (produkList) => emit(ProdukLoaded(
        produkList,
        originalList: produkList,
        sortOrder: SortOrder.defaultOrder,
      )),
    );
  }

  void sortProduk({required bool? ascending}) {
    if (state is ProdukLoaded) {
      final currentState = state as ProdukLoaded;
      final originalList = currentState.originalList;
      
      if (ascending == null) {
        emit(ProdukLoaded(
          List.of(originalList),
          originalList: originalList,
          sortOrder: SortOrder.defaultOrder,
        ));
      } else if (ascending) {
        final sortedList = List.of(originalList)
          ..sort((a, b) => a.harga.compareTo(b.harga));
        emit(ProdukLoaded(
          sortedList,
          originalList: originalList,
          sortOrder: SortOrder.ascending,
        ));
      } else {
        final sortedList = List.of(originalList)
          ..sort((a, b) => b.harga.compareTo(a.harga));
        emit(ProdukLoaded(
          sortedList,
          originalList: originalList,
          sortOrder: SortOrder.descending,
        ));
      }
    }
  }
}
