enum PaymentMethod {
  cash('Tunai', '💵'),
  qris('QRIS', '📱'),
  transfer('Transfer Bank', '🏦');

  final String displayName;
  final String icon;

  const PaymentMethod(this.displayName, this.icon);
}
