import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:menu_makanan/model/lokasi_penjual.dart';
import 'package:menu_makanan/services/lokasi_penjual_service.dart';
import 'package:menu_makanan/services/lokasi_penjual_api.dart';

class HalamanLokasi extends StatefulWidget {
  final List<String>? filterIds; // optional list of lokasi IDs to highlight
  final String? focusId; // optional single lokasi ID to focus camera on

  const HalamanLokasi({super.key, this.filterIds, this.focusId});

  @override
  State<HalamanLokasi> createState() => _HalamanLokasiState();
}

class _HalamanLokasiState extends State<HalamanLokasi> {
  GoogleMapController? mapController;
  final Location _location = Location();

  Set<Marker> markers = {};
  List<LokasiPenjual> semuaLokasiPenjual = [];
  LokasiPenjual? lokasiPenjualDipilih;

  LatLng _kameraPosition = const LatLng(-7.2504, 112.7488); // Surabaya
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLokasiPenjual();
    // Only request device location on mobile/desktop — skip on web
    if (!kIsWeb) {
      _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final userLocation = await _location.getLocation();
      setState(() {
        _kameraPosition = LatLng(
          userLocation.latitude!,
          userLocation.longitude!,
        );
      });
    } catch (e) {
      debugPrint('Error requesting location: $e');
    }
  }

  Future<void> _loadLokasiPenjual() async {
    try {
      // On web, prefer fetching from the local dev API server if available.
      final lokasiList = kIsWeb
          ? await LokasiPenjualApi.fetchSemuaLokasi()
          : await LokasiPenjualService.getSemuaLokasiPenjual();

      Set<Marker> markerSet = {};
      for (var lokasi in lokasiList) {
        final isHighlighted =
            widget.filterIds != null && widget.filterIds!.contains(lokasi.id);
        markerSet.add(
          Marker(
            markerId: MarkerId(lokasi.id),
            position: lokasi.latLng,
            infoWindow: InfoWindow(
              title: lokasi.nama,
              snippet: lokasi.alamat,
              onTap: () => _showLokasiDetail(lokasi),
            ),
            onTap: () => _showLokasiDetail(lokasi),
            icon: isHighlighted
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange,
                  )
                : BitmapDescriptor.defaultMarker,
          ),
        );
      }

      // Jika ada focusId, cari lokasi fokus lalu set kamera position ke lokasi tersebut.
      LokasiPenjual? fokusLokasi;
      if (widget.focusId != null) {
        try {
          fokusLokasi = lokasiList.firstWhere((l) => l.id == widget.focusId);
        } catch (e) {
          fokusLokasi = lokasiList.isNotEmpty ? lokasiList.first : null;
        }
        if (fokusLokasi != null) {
          _kameraPosition = fokusLokasi.latLng;
        }
      }

      setState(() {
        semuaLokasiPenjual = lokasiList;
        markers = markerSet;
        _isLoading = false;
      });

      // Tampilkan bottom sheet detail otomatis jika ada fokus
      if (fokusLokasi != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Jika map controller sudah tersedia, animate camera
          try {
            mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(fokusLokasi!.latLng, 16),
            );
          } catch (_) {}
          _showLokasiDetail(fokusLokasi!);
        });
      }
    } catch (e) {
      debugPrint('Error loading lokasi penjual: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLokasiDetail(LokasiPenjual lokasi) {
    setState(() {
      lokasiPenjualDipilih = lokasi;
    });

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildLokasiDetailSheet(lokasi),
    );
  }

  Widget _buildLokasiDetailSheet(LokasiPenjual lokasi) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan foto dan rating
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(lokasi.fotoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nama dan rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lokasi.nama,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            lokasi.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Alamat
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lokasi.alamat,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Nomor telepon
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lokasi.nomorTelepon,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Jam buka
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${lokasi.jamBuka} - ${lokasi.jamTutup}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Kategori makanan
            const Text(
              'Menu Tersedia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: lokasi.kategoriMakanan
                  .map(
                    (kategori) => Chip(
                      label: Text(kategori),
                      backgroundColor: Colors.orange.shade100,
                      labelStyle: const TextStyle(color: Colors.orange),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Tombol navigasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implementasi navigasi ke aplikasi maps
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Membuka Google Maps untuk ${lokasi.nama}...',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions),
                    SizedBox(width: 8),
                    Text('Navigasi ke Lokasi'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Tombol tutup
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Penjual'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Google Map
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _kameraPosition,
                    zoom: 14,
                  ),
                  markers: markers,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                ),

                // List lokasi di bawah
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(8),
                      itemCount: semuaLokasiPenjual.length,
                      itemBuilder: (context, index) {
                        final lokasi = semuaLokasiPenjual[index];
                        return _buildLokasiCard(lokasi);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLokasiCard(LokasiPenjual lokasi) {
    return GestureDetector(
      onTap: () => _showLokasiDetail(lokasi),
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: lokasiPenjualDipilih?.id == lokasi.id
                ? Colors.orange
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lokasi.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    lokasi.rating.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                lokasi.alamat,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controller if initialized
    mapController?.dispose();
    super.dispose();
  }
}
