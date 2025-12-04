    emit(ProdukLoading());
    final result = event.category == ProdukCategory.makanan
        ? await getAllProdukUseCase()
        : await getAllMinumanUseCase();

    result.fold(
      (failure) => emit(ProdukError(failure.message)),
      (produkList) => emit(ProdukLoaded(produkList)),
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
      (produkList) => emit(ProdukLoaded(produkList)),
    );
  }
}
