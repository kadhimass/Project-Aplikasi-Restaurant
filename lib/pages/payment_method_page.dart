import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_makanan/model/payment_method.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/providers/payment_provider.dart';

class PaymentMethodPage extends StatelessWidget {
  final Keranjang keranjang;
  final String email;

  const PaymentMethodPage({
    super.key,
    required this.keranjang,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Metode Pembayaran'),
        automaticallyImplyLeading: true,
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: PaymentMethod.values.map((m) {
                      return Card(
                        child: ListTile(
                          leading: Text(
                            m.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(m.displayName),
                          trailing: Radio<PaymentMethod>(
                            value: m,
                            groupValue: paymentProvider.selectedPaymentMethod,
                            onChanged: (v) {
                              if (v != null) {
                                paymentProvider.selectPaymentMethod(v);
                              }
                            },
                          ),
                          onTap: () {
                            paymentProvider.selectPaymentMethod(m);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: paymentProvider.selectedPaymentMethod == null
                        ? null
                        : () {
                            // Navigate to order details page
                            context.pushNamed(
                              'order-details',
                              extra: {
                                'keranjang': keranjang,
                                'paymentMethod':
                                    paymentProvider.selectedPaymentMethod!,
                                'email': email,
                              },
                            );
                          },
                    child: const Text('Lanjutkan ke Detail Pesanan'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
