import 'package:intl/intl.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/transaksi.dart';

/// CartService provides cart-related calculations and formatting operations.
/// This service encapsulates business logic for cart management, discount calculation,
/// and transaction processing.
class CartService {
  static const double discountThreshold = 100000.0;
  static const double discountAmount = 10000.0;

  /// Calculate subtotal from cart items
  static double calculateSubtotal(Keranjang keranjang) {
    double total = 0;
    for (var item in keranjang.items) {
      total += item.produk.harga * item.jumlah;
    }
    return total;
  }

  /// Check if cart is eligible for discount
  static bool isEligibleForDiscount(double subtotal) {
    return subtotal >= discountThreshold;
  }

  /// Calculate discount amount if applicable
  static double calculateDiscount(double subtotal) {
    return isEligibleForDiscount(subtotal) ? discountAmount : 0;
  }

  /// Calculate final price after discount
  static double calculateFinalPrice(double subtotal) {
    final discount = calculateDiscount(subtotal);
    return subtotal - discount;
  }

  /// Generate unique transaction ID based on timestamp
  static String generateTransactionId() {
    return 'WRKT${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Format currency to Rupiah format
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Get cart summary data for checkout
  static CartSummary getCartSummary(Keranjang keranjang) {
    final subtotal = calculateSubtotal(keranjang);
    final discount = calculateDiscount(subtotal);
    final finalPrice = calculateFinalPrice(subtotal);

    return CartSummary(
      subtotal: subtotal,
      discount: discount,
      finalPrice: finalPrice,
      isEligibleForDiscount: isEligibleForDiscount(subtotal),
      itemCount: keranjang.totalItem,
    );
  }

  /// Create transaction from cart and checkout data
  static Transaksi createTransaction({
    required Keranjang keranjang,
    required String email,
  }) {
    return Transaksi(
      keranjang: keranjang,
      email: email,
      idTransaksi: generateTransactionId(),
      waktuTransaksi: DateTime.now(),
    );
  }
}

/// Data class for cart summary information
class CartSummary {
  final double subtotal;
  final double discount;
  final double finalPrice;
  final bool isEligibleForDiscount;
  final int itemCount;

  CartSummary({
    required this.subtotal,
    required this.discount,
    required this.finalPrice,
    required this.isEligibleForDiscount,
    required this.itemCount,
  });

  /// Format summary for display
  String getFormattedSubtotal() => CartService.formatCurrency(subtotal);
  String getFormattedDiscount() => CartService.formatCurrency(discount);
  String getFormattedFinalPrice() => CartService.formatCurrency(finalPrice);
}
