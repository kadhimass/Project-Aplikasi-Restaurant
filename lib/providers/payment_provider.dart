import 'package:flutter/foundation.dart';
import 'package:menu_makanan/model/payment_method.dart';

class PaymentProvider with ChangeNotifier {
  PaymentMethod? _selectedPaymentMethod;

  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;

  void selectPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  void reset() {
    _selectedPaymentMethod = null;
    notifyListeners();
  }
}
