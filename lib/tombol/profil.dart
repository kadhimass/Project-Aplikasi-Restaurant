import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class HalamanProfil extends StatefulWidget {
  final String email;
  const HalamanProfil({super.key, required this.email});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  Map<String, String> _deviceData = {};
  XFile? _imageFile; // Changed from File to XFile for web compatibility
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String> deviceData = {};
    try {
      if (kIsWeb) {
        final WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
        deviceData = {
          'Model Perangkat': '${webInfo.browserName} ${webInfo.appVersion}',
          'Platform': 'Web',
        };
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;
        deviceData = {
          'Model Perangkat': '${androidInfo.manufacturer} ${androidInfo.model}',
          'Versi Android': androidInfo.version.release,
        };
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = {
          'Model Perangkat': iosInfo.name,
          'Versi iOS': iosInfo.systemVersion,
        };
      }
    } catch (e) {
      deviceData = {'Error': 'Gagal mendapatkan info perangkat: $e'};
    }
    if (mounted) {
      setState(() {
        _deviceData = deviceData;
      });
    }
  }

  Future<void> _checkPermission() async {
    // Only request photo/gallery permission, no camera needed
    if (kIsWeb) {
      // On web, directly pick from gallery (no permissions needed)
      _pickImageFromGallery();
    } else {
      // On mobile, request photos permission only
      PermissionStatus status = await Permission.photos.request();

      if (mounted) {
        if (status.isGranted || status.isLimited) {
          _pickImageFromGallery();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Izin Galeri Ditolak! Mohon berikan izin di pengaturan."),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Buka Pengaturan',
                onPressed: () {
                  openAppSettings();
                },
              ),
            ),
          );
        }
      }
    }
  }

  // Directly pick from gallery (removed modal dialog)
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Always use gallery
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile; // Store XFile directly
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Foto profil berhasil diperbarui!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengambil gambar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: _BagianAtas(
              email: widget.email,
              onEditProfile: _checkPermission,
              imageFile: _imageFile,
            )),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Text(
                  'Halo, ${widget.email}',
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
        final transactionCount =
            transactionProvider.transactionsForUser(email).length;
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
  final VoidCallback onEditProfile;
  final XFile? imageFile; // Changed from File to XFile

  const _BagianAtas({
    required this.email,
    required this.onEditProfile,
    this.imageFile,
  });

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
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: imageFile != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: kIsWeb
                                ? NetworkImage(imageFile!.path) // Use NetworkImage for web
                                : FileImage(File(imageFile!.path)) as ImageProvider,
                          )
                        : const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/LOGO.png'),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.orange),
                      onPressed: onEditProfile,
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
