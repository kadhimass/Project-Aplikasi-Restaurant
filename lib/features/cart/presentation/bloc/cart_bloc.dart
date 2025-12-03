import 'package:bloc/bloc.dart';
import 'package:menu_makanan/features/cart/domain/repositories/cart_repository.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final newCart = state.cart.addItem(event.produk);
    await cartRepository.saveCart(newCart);
    emit(state.copyWith(cart: newCart));
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    final newCart = state.cart.removeItem(event.produk);
    await cartRepository.saveCart(newCart);
    emit(state.copyWith(cart: newCart));
  }

  Future<void> _onDecreaseQuantity(
    DecreaseQuantity event,
    Emitter<CartState> emit,
  ) async {
    final newCart = state.cart.decreaseQuantity(event.produk);
    await cartRepository.saveCart(newCart);
    emit(state.copyWith(cart: newCart));
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    final newCart = state.cart.updateQuantity(event.produk, event.quantity);
    await cartRepository.saveCart(newCart);
    emit(state.copyWith(cart: newCart));
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final newCart = state.cart.clear();
    await cartRepository.saveCart(newCart);
    emit(state.copyWith(cart: newCart));
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final cart = await cartRepository.loadCart();
      emit(state.copyWith(cart: cart, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
