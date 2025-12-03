enum PaymentMethod { dana, qris, tunai }

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.dana:
        return 'Dana';
      case PaymentMethod.qris:
        return 'QRIS';
      case PaymentMethod.tunai:
        return 'Tunai';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.dana:
        return '💳';
      case PaymentMethod.qris:
        return '📱';
      case PaymentMethod.tunai:
        return '💵';
    }
  }
}
