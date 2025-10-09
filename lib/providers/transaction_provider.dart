import 'package:flutter/material.dart';
import 'package:menu_makanan/model/transaksi.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaksi> _transactions = [];

  List<Transaksi> get transactions => List.unmodifiable(_transactions);

  // Helper to get transactions for a specific user
  List<Transaksi> transactionsForUser(String email) {
    return _transactions.where((tx) => tx.email == email).toList();
  }

  void addTransaction(Transaksi transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Method to remove a transaction by its ID
  void removeTransaction(String transactionId) {
    _transactions.removeWhere((tx) => tx.idTransaksi == transactionId);
    notifyListeners();
  }
}
