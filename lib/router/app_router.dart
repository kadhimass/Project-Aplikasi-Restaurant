import 'package:go_router/go_router.dart';
import 'package:menu_makanan/features/product/presentation/pages/product_list_page.dart'; // Check if this exists
import 'package:menu_makanan/features/auth/presentation/pages/login_page.dart';
import 'package:menu_makanan/features/auth/presentation/pages/register_page.dart';
import 'package:menu_makanan/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:menu_makanan/features/common/presentation/pages/webview_page.dart';
import 'package:menu_makanan/features/profile/presentation/pages/about_us_page.dart';
import 'package:menu_makanan/features/history/presentation/pages/history_page.dart';
import 'package:menu_makanan/features/product/presentation/pages/product_detail_page.dart';
import 'package:menu_makanan/features/history/presentation/pages/transaction_proof_page.dart';
import 'package:menu_makanan/features/common/presentation/pages/splash_screen.dart';
import 'package:menu_makanan/features/home/presentation/pages/main_screen.dart' show MainScreen;
import 'package:menu_makanan/features/profile/presentation/pages/profile_page.dart' show HalamanProfil;
import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/features/cart/presentation/pages/payment_method_page.dart';
import 'package:menu_makanan/features/history/presentation/pages/order_details_page.dart';

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
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] as String? ?? '';
          return ProdukListPage(email: email);
        },
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
          return HalamanDetail(produk: produk!);
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
        name: 'payment',
        path: '/payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final keranjang = extra?['keranjang'];
          final email = extra?['email'] as String? ?? '';
          return PaymentMethodPage(keranjang: keranjang, email: email);
        },
      ),
      GoRoute(
        name: 'order-details',
        path: '/order-details',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final keranjang = extra?['keranjang'];
          final paymentMethod = extra?['paymentMethod'];
          final email = extra?['email'] as String? ?? '';
          return OrderDetailsPage(
            keranjang: keranjang,
            paymentMethod: paymentMethod,
            email: email,
          );
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
