import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_makanan/features/cart/domain/entities/cart.dart';
import 'package:menu_makanan/model/payment_method.dart';
import 'package:menu_makanan/model/transaksi.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_event.dart';
import 'package:menu_makanan/features/history/presentation/pages/transaction_proof_page.dart';

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
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Pesanan Anda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 16),
            const Text(
              'Daftar Pesanan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: keranjang.items.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, i) {
                        final item = keranjang.items[i];
                        final name = item.produk.nama;
                        final qty = item.jumlah;
                        final price = item.produk.harga;
                        final subtotal = price * qty;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(name),
                          subtitle: Text('${_formatPrice(price)} x $qty'),
                          trailing: Text(
                            _formatPrice(subtotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Metode Pembayaran:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.payment, color: Colors.orange),
                title: Text(paymentMethod.displayName),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text(_formatPrice(keranjang.totalHarga)),
                      ],
                    ),
                    if (keranjang.dapatDiskon) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Diskon:', style: TextStyle(color: Colors.green)),
                          Text(
                            '-${_formatPrice(keranjang.jumlahDiskon)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatPrice(keranjang.hargaSetelahDiskon),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Buat transaksi
                  final transaksi = Transaksi(
                    keranjang: keranjang,
                    email: email,
                    idTransaksi: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
                    waktuTransaksi: DateTime.now(),
                  );

                  // Simpan ke provider
                  Provider.of<TransactionProvider>(context, listen: false)
                      .addTransaction(transaksi);

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
          ],
        ),
      ),
    );
  }
}
