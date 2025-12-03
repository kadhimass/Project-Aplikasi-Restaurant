import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_makanan/pages/halaman_beranda.dart';
import 'package:menu_makanan/pages/halaman_login.dart';
import 'package:menu_makanan/pages/halaman_registrasi.dart';
import 'package:menu_makanan/pages/halaman_password.dart';
import 'package:menu_makanan/pages/halaman_webview.dart';
import 'package:menu_makanan/pages/halaman_about_us.dart';
import 'package:menu_makanan/pages/halaman_riwayat.dart';
import 'package:menu_makanan/pages/halaman_detailproduk.dart';
import 'package:menu_makanan/pages/halaman_buktitransaksi.dart';
import 'package:menu_makanan/pages/loading.dart';
import 'package:menu_makanan/pages/halaman_appbar.dart' show MainScreen;
import 'package:menu_makanan/tombol/profil.dart' show HalamanProfil;
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/produk.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        name: 'splash',
        path: '/splash',
        builder: (context, state) => const Loading(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const HalamanLogin(),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) => const HalamanRegistrasi(),
      ),
      GoRoute(
        name: 'forgot',
        path: '/forgot',
        builder: (context, state) => const HalamanLupaPassword(),
      ),
      GoRoute(
        name: 'profil',
        path: '/profil',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] as String? ?? '';
          return HalamanProfil(email: email);
        },
      ),
      GoRoute(
        name: 'beranda',
        path: '/beranda',
        builder: (context, state) => HalamanBeranda(
          email: '',
          keranjang: Keranjang(),
          onAddToCart: (Produk p1) {},
        ),
      ),
      GoRoute(
        name: 'riwayat',
        path: '/riwayat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] as String? ?? '';
          return HalamanRiwayat(email: email);
        },
      ),
      GoRoute(
        name: 'detail',
        path: '/detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final produk = extra?['produk'] as Produk?;
          final onTambah = extra?['onTambah'] as VoidCallback?;
          return HalamanDetail(produk: produk!, onTambahKeKeranjang: onTambah);
        },
      ),
      GoRoute(
        name: 'webview',
        path: '/webview',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final title = extra?['title'] as String? ?? '';
          final url = extra?['url'] as String? ?? '';
          return HalamanWebView(title: title, url: url);
        },
      ),
      GoRoute(
        name: 'bukti',
        path: '/bukti',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final keranjang = extra?['keranjang'];
          final email = extra?['email'] as String? ?? '';
          final idTransaksi = extra?['idTransaksi'] as String? ?? '';
          final waktuTransaksi =
              extra?['waktuTransaksi'] as DateTime? ?? DateTime.now();
          final metodePembayaran = extra?['metodePembayaran'] as String?;
          return HalamanBuktiTransaksi(
            keranjang: keranjang,
            email: email,
            idTransaksi: idTransaksi,
            waktuTransaksi: waktuTransaksi,
            metodePembayaran: metodePembayaran,
          );
        },
      ),
      GoRoute(
        name: 'about',
        path: '/about',
        builder: (context, state) => const AboutUs(),
      ),
      GoRoute(
        name: 'main',
        path: '/main',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] as String? ?? '';
          return MainScreen(email: email);
        },
      ),
    ],
  );
}
