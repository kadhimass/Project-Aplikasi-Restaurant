import 'package:flutter/material.dart';
import 'package:menu_makanan/halaman_buktitransaksi.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';

class HalamanRiwayat extends StatefulWidget {
  final String email;
  const HalamanRiwayat({super.key, required this.email});

  @override
  State<HalamanRiwayat> createState() => _HalamanRiwayatState();
}

class _HalamanRiwayatState extends State<HalamanRiwayat> {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactionsForUser(widget.email);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text('Belum ada riwayat transaksi.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaksi = transactions[index];
                return Dismissible(
                  key: Key(transaksi.idTransaksi),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Konfirmasi Hapus"),
                          content: const Text("Apakah Anda yakin ingin menghapus transaksi ini?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Hapus"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    transactionProvider.removeTransaction(transaksi.idTransaksi);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transaksi ${transaksi.idTransaksi} dihapus')),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HalamanBuktiTransaksi(
                              keranjang: transaksi.keranjang,
                              email: transaksi.email,
                              idTransaksi: transaksi.idTransaksi,
                              waktuTransaksi: transaksi.waktuTransaksi,
                            ),
                          ),
                        );
                      },
                      title: Text('ID Transaksi: ${transaksi.idTransaksi}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanggal: ${DateFormat('dd MMMM yyyy, HH:mm').format(transaksi.waktuTransaksi)}'),
                          Text('Total: Rp${transaksi.keranjang.totalHarga.toStringAsFixed(0)}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
