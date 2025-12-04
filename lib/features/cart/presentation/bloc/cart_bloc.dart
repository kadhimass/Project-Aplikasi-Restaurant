import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final newCart = state.cart.addItem(event.produk);
    emit(state.copyWith(cart: newCart));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final newCart = state.cart.removeItem(event.produk);
    emit(state.copyWith(cart: newCart));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartState.initial());
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final newCart = state.cart.updateQuantity(event.produk, event.quantity);
    emit(state.copyWith(cart: newCart));
  }

  void _onDecreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) {
    final newCart = state.cart.decreaseQuantity(event.produk);
    emit(state.copyWith(cart: newCart));
  }
}
