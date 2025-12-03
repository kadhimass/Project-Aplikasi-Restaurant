import 'package:flutter/material.dart';
import 'package:menu_makanan/model/payment_method.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_makanan/bloc/cart_bloc.dart';
import 'package:menu_makanan/bloc/cart_event.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/transaksi.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsPage extends StatelessWidget {
  final Keranjang keranjang;
  final PaymentMethod paymentMethod;
  final String email;

  const OrderDetailsPage({
    Key? key,
    required this.keranjang,
    required this.paymentMethod,
    required this.email,
  }) : super(key: key);

  String _formatPrice(num value) => 'Rp${value.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
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
                      separatorBuilder: (_, __) => const Divider(),
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
                    keranjang: Keranjang(initialItems: keranjang.items),
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

                  // navigate to bukti page (keep bukti page behavior: shows success and allows download)
                  context.pushNamed(
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
