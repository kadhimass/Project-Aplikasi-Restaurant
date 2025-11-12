import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:menu_makanan/halaman_webview.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';

class HalamanProfil extends StatefulWidget {
  final String email;
  const HalamanProfil({super.key, required this.email});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  Map<String, String> _deviceData = {}; // Variabel untuk simpan data perangkat

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String> deviceData = {};
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;
        deviceData = {
          'Model Perangkat': '${androidInfo.manufacturer} ${androidInfo.model}',
          'Versi Android': androidInfo.version.release ?? 'N/A',
        };
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = {
          'Model Perangkat': iosInfo.name,
          'Versi iOS': iosInfo.systemVersion ?? 'N/A',
        };
      }
    } catch (e) {
      deviceData = {'Error': 'Gagal mendapatkan info perangkat.'};
    }
    if (mounted) {
      setState(() {
        _deviceData = deviceData;
      });
    }
  }
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: _BagianAtas(email: widget.email)),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Text(
                  'Halo, ${widget.email}', // <-- Gunakan widget.email
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {},
                      elevation: 0,
                      label: const Text("Status: Pelanggan Setia"),
                      icon: const Icon(Icons.verified_user_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _BarisInfoProfil(email: widget.email),
                const SizedBox(height: 16),

                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informasi Perangkat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        if (_deviceData.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else
                          ..._deviceData.entries.map((entry) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.chevron_right),
                              title: Text(entry.key),
                              subtitle: Text(entry.value),
                            );
                          }),
                      ],
                    ),
                  ),
                ),

                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.description_outlined,
                          color: Colors.orange,
                        ),
                        title: const Text("Syarat & Ketentuan"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          context.pushNamed(
                            'webview',
                            extra: {
                              'title': 'Syarat & Ketentuan',
                              'url':
                                  'https://drive.google.com/file/d/1HIqyw2_hWnozTk-qiqHxcvt5VlNIAYYp/view?usp=drivesdk',
                            },
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(
                          Icons.privacy_tip_outlined,
                          color: Colors.orange,
                        ),
                        title: const Text("Kebijakan Privasi"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          context.pushNamed(
                            'webview',
                            extra: {
                              'title': 'Kebijakan Privasi',
                              'url':
                                  'https://drive.google.com/file/d/1mFrBpbDOFbHiubDACQW1AMvIrCzX8s6g/view?usp=drivesdk',
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // ==========================================================
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BarisInfoProfil extends StatelessWidget {
  final String email;
  const _BarisInfoProfil({required this.email});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final transactionCount = transactionProvider
            .transactionsForUser(email)
            .length;
        final List<ItemInfoProfil> items = [
          ItemInfoProfil("Jumlah Transaksi", transactionCount),
        ];

        return Container(
          height: 80,
          constraints: const BoxConstraints(maxWidth: 400),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items
                .map(
                  (item) => Expanded(
                    child: Row(
                      children: [
                        if (items.indexOf(item) != 0) const VerticalDivider(),
                        Expanded(child: _itemTunggal(context, item)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _itemTunggal(BuildContext context, ItemInfoProfil item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item.nilai.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      Text(item.judul, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class ItemInfoProfil {
  final String judul;
  final int nilai;
  const ItemInfoProfil(this.judul, this.nilai);
}

class _BagianAtas extends StatelessWidget {
  final String email;
  const _BagianAtas({required this.email});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 125,
            height: 125,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/LOGO.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
