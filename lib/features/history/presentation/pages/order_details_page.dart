import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/features/history/presentation/pages/order_details_page.dart
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_makanan/features/cart/domain/entities/cart.dart';
import 'package:menu_makanan/model/payment_method.dart';
import 'package:menu_makanan/model/transaksi.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/features/history/presentation/pages/transaction_proof_page.dart';
=======
import 'package:menu_makanan/model/payment_method.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/transaksi.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
>>>>>>> 304aae5a4f5f1d45bc8aca21c7f0b3cb74fa1c5c:lib/pages/order_details_page.dart

class OrderDetailsPage extends StatelessWidget {
  final Cart keranjang;
  final PaymentMethod paymentMethod;
  final String email;

  const OrderDetailsPage({
    super.key,
    required this.keranjang,
    required this.paymentMethod,
    required this.email,
  });

  String _formatPrice(num value) => 'Rp${value.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Pesanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: keranjang.items.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, i) {
                        final item = keranjang.items[i];
                        final name = item.produk.nama;
                        final qty = item.jumlah;
                        final price = item.produk.harga;
                        return ListTile(
                          title: Text(name),
                          subtitle: Text('Jumlah: $qty'),
                          trailing: Text(_formatPrice(price * qty)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.orange.shade50,
                    child: ListTile(
                      leading: Text(
                        paymentMethod.icon,
                        style: const TextStyle(fontSize: 30),
                      ),
                      title: Text(paymentMethod.displayName),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text(
                        'Total Harga',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        _formatPrice(keranjang.hargaSetelahDiskon),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Create transaksi, simpan ke provider, kosongkan keranjang, dan buka bukti
                  final idTransaksi =
                      'WRKT${DateTime.now().millisecondsSinceEpoch}';
                  final waktuTransaksi = DateTime.now();

                  final transaksi = Transaksi(
                    keranjang: keranjang, // Using Cart directly
                    email: email,
                    idTransaksi: idTransaksi,
                    waktuTransaksi: waktuTransaksi,
                  );

                  Provider.of<TransactionProvider>(
                    context,
                    listen: false,
                  ).addTransaction(transaksi);

                  // kosongkan keranjang melalui bloc
                  context.read<CartBloc>().add(ClearCart());

                  // Navigate to bukti page menggunakan go_router
                  context.pushReplacementNamed(
                    'bukti',
                    extra: {
                      'keranjang': transaksi.keranjang,
                      'email': transaksi.email,
                      'idTransaksi': transaksi.idTransaksi,
                      'waktuTransaksi': transaksi.waktuTransaksi,
                      'metodePembayaran': paymentMethod.displayName,
                    },
                  );
                },
                child: const Text('Konfirmasi Pesanan'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
