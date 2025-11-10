# TODO: Fix Cart Quantity Increase

## Information Gathered
- The `Keranjang` model already has `tambahItem` method that increases quantity if item exists.
- The BLoC is set up but the UI in `halaman_keranjang.dart` directly modifies `widget.keranjang` instead of dispatching events, causing inconsistency.
- Missing `DecreaseQuantity` event for reducing items.
- The page takes a `keranjang` parameter, but with BLoC, it should use `state.keranjang`.

## Plan
- Add `DecreaseQuantity` event to `cart_event.dart`.
- Add handler for `DecreaseQuantity` in `cart_bloc.dart`.
- Modify `halaman_keranjang.dart`:
  - Remove `keranjang` parameter from constructor.
  - Change all `widget.keranjang` to `state.keranjang`.
  - Update `_tambahItem` to dispatch `AddToCart`.
  - Update `_kurangiItem` to dispatch `DecreaseQuantity`.
  - Update `_hapusItem` to dispatch `RemoveFromCart`.
  - Update `_kosongkanKeranjang` to dispatch `ClearCart`.
  - Remove unused `_updateKeranjang`.
- Ensure navigation and other parts use `state.keranjang`.

## Dependent Files to be edited
- `lib/bloc/cart_event.dart`
- `lib/bloc/cart_bloc.dart`
- `lib/halaman_keranjang.dart`

## Followup steps
- Test the cart functionality to ensure quantity increases properly.
- Check if other pages using the cart need updates.
