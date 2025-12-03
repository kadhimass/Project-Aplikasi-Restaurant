import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_makanan/features/produk/domain/usecases/get_all_produk_usecase.dart';
import 'package:menu_makanan/features/produk/domain/usecases/get_all_minuman_usecase.dart';
import 'package:menu_makanan/features/produk/domain/usecases/search_produk_usecase.dart';
import 'package:menu_makanan/features/produk/domain/usecases/search_minuman_usecase.dart';
import 'package:menu_makanan/features/produk/presentation/bloc/produk_state.dart';

enum ProdukCategory { makanan, minuman }

class ProdukCubit extends Cubit<ProdukState> {
  final GetAllProdukUseCase getAllProdukUseCase;
  final GetAllMinumanUseCase getAllMinumanUseCase;
  final SearchProdukUseCase searchProdukUseCase;
  final SearchMinumanUseCase searchMinumanUseCase;

  ProdukCubit({
    required this.getAllProdukUseCase,
    required this.getAllMinumanUseCase,
    required this.searchProdukUseCase,
    required this.searchMinumanUseCase,
  }) : super(ProdukInitial());

  Future<void> getProduk({ProdukCategory category = ProdukCategory.makanan}) async {
    emit(ProdukLoading());
    final result = category == ProdukCategory.makanan
        ? await getAllProdukUseCase()
        : await getAllMinumanUseCase();

    result.fold(
      (failure) => emit(ProdukError(failure.message)),
      (produkList) => emit(ProdukLoaded(
        produkList,
        originalList: List.unmodifiable(produkList),
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
        originalList: List.unmodifiable(produkList),
        sortOrder: SortOrder.defaultOrder,
      )),
    );
  }

  void sortProduk({required bool? ascending}) {
    if (state is ProdukLoaded) {
      final currentState = state as ProdukLoaded;
      final originalList = currentState.originalList;
      
      print('Sorting: ascending=$ascending');
      print('Original List first item: ${originalList.isNotEmpty ? originalList.first.nama : "Empty"}');
      
      if (ascending == null) {
        // Default sort (original order)
        emit(ProdukLoaded(
          List.of(originalList),
          originalList: originalList,
          sortOrder: SortOrder.defaultOrder,
        ));
      } else if (ascending) {
        final sortedList = List.of(originalList)
          ..sort((a, b) => a.harga.compareTo(b.harga));
        print('Sorted List first item: ${sortedList.isNotEmpty ? sortedList.first.nama : "Empty"}');
        emit(ProdukLoaded(
          sortedList,
          originalList: originalList,
          sortOrder: SortOrder.ascending,
        ));
      } else {
        final sortedList = List.of(originalList)
          ..sort((a, b) => b.harga.compareTo(a.harga));
        print('Sorted List first item: ${sortedList.isNotEmpty ? sortedList.first.nama : "Empty"}');
        emit(ProdukLoaded(
          sortedList,
          originalList: originalList,
          sortOrder: SortOrder.descending,
        ));
      }
    }
  }
}
