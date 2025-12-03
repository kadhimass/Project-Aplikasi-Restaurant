import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/model/payment_method.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/providers/payment_provider.dart';
import 'package:menu_makanan/pages/order_details_page.dart';

class PaymentMethodPage extends StatelessWidget {
  final Keranjang keranjang;
  final String email;

  const PaymentMethodPage({
    Key? key,
    required this.keranjang,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Metode Pembayaran')),
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
                              if (v != null)
                                paymentProvider.selectPaymentMethod(v);
                            },
                          ),
                          onTap: () => paymentProvider.selectPaymentMethod(m),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailsPage(
                                  keranjang: keranjang,
                                  paymentMethod:
                                      paymentProvider.selectedPaymentMethod!,
                                  email: email,
                                ),
                              ),
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
