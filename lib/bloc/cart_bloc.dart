import 'package:bloc/bloc.dart';
import 'package:menu_makanan/bloc/cart_event.dart';
import 'package:menu_makanan/bloc/cart_state.dart';
import 'package:menu_makanan/model/keranjang.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final newKeranjang = Keranjang(initialItems: List.from(state.keranjang.items));
    newKeranjang.tambahItem(event.produk);
    emit(state.copyWith(keranjang: newKeranjang));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final newKeranjang = Keranjang(initialItems: List.from(state.keranjang.items));
    newKeranjang.hapusItem(event.produk);
    emit(state.copyWith(keranjang: newKeranjang));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartState.initial());
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final newKeranjang = Keranjang(initialItems: List.from(state.keranjang.items));
    final existingItemIndex = newKeranjang.items.indexWhere((item) => item.produk.id == event.produk.id);
    if (existingItemIndex >= 0) {
      if (event.quantity > 0) {
        // Update quantity by removing and adding new item
        newKeranjang.hapusItem(event.produk);
        newKeranjang.tambahItem(event.produk);
        // Adjust quantity by adding/removing as needed
        for (int i = 1; i < event.quantity; i++) {
          newKeranjang.tambahItem(event.produk);
        }
      } else {
        newKeranjang.hapusItem(event.produk);
      }
    } else if (event.quantity > 0) {
      for (int i = 0; i < event.quantity; i++) {
        newKeranjang.tambahItem(event.produk);
      }
    }
    emit(state.copyWith(keranjang: newKeranjang));
  }

  void _onDecreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) {
    final newKeranjang = Keranjang(initialItems: List.from(state.keranjang.items));
    newKeranjang.kurangiItem(event.produk);
    emit(state.copyWith(keranjang: newKeranjang));
  }
}
