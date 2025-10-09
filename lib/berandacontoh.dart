/* BERANDA PERTAMA

import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:menu_makanan/halaman_detailproduk.dart';
import 'package:menu_makanan/model/dummydata.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/produk.dart';


class HalamanBeranda extends StatelessWidget {
  final Keranjang keranjang;
  final String email;
  final Function(Produk) onAddToCart;

  const HalamanBeranda({
    super.key,
    required this.keranjang,
    required this.email,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    List<Produk> produkList = DummyData.getProdukList();

    return Column(
      children: [
        // Banner promo
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.orange.shade100,
          child: const Row(
            children: [
              Icon(Icons.local_offer, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Diskon Rp 10.000 untuk pesanan di atas Rp 50.000',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Daftar produk
        Expanded(
          child: ListView.builder(
            itemCount: produkList.length,
            itemBuilder: (context, index) {
              final produk = produkList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      produk.gambar,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey,
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    produk.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        produk.deskripsi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          AnimatedRatingStars(
                            initialRating: produk.rating.toDouble(),
                            minRating: 0.0,
                            maxRating: 5.0,
                            filledColor: Colors.amber,
                            emptyColor: Colors.grey,
                            filledIcon: Icons.star,
                            halfFilledIcon: Icons.star_half,
                            emptyIcon: Icons.star_border,
                            onChanged: (double rating) {
                              // Handle the rating change here
                              print('Rating: $rating');
                            },
                            displayRatingValue: true,
                            interactiveTooltips: true,
                            customFilledIcon: Icons.star,
                            customHalfFilledIcon: Icons.star_half,
                            customEmptyIcon: Icons.star_border,
                            starSize: 30.0,
                            animationDuration: const Duration(milliseconds: 300),
                            animationCurve: Curves.easeInOut,
                            readOnly: true,
                          ),
                          /*Icon(
                            Icons.star,
                            color: Colors.orange.shade500,
                            size: 16,
                          ),*/
                          Text(
                            produk.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Rp${produk.harga.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  /*trailing: GFIconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.orange),
                    onPressed: (){
                      onAddToCart(produk);
                    },
                    //text: "primary",
                    //size: GFSize.small,
                  ),*/
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      onAddToCart(produk);
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HalamanDetail(
                          produk: produk,
                          onTambahKeKeranjang: () {
                            onAddToCart(produk);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}*/

/* BERANDA KE 2
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart'; // <-- JANGAN LUPA IMPORT INI
import 'package:menu_makanan/halaman_detailproduk.dart';
import 'package:menu_makanan/model/dummydata.dart';
import 'package:menu_makanan/model/keranjang.dart';
import 'package:menu_makanan/model/produk.dart';

class HalamanBeranda extends StatelessWidget {
  final Keranjang keranjang;
  final String email;
  final Function(Produk) onAddToCart;

  const HalamanBeranda({
    super.key,
    required this.keranjang,
    required this.email,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    List<Produk> produkList = DummyData.getProdukList();

    return Column(
      children: [
        // Banner promo (tidak diubah, sudah bagus)
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.orange.shade100,
          child: const Row(
            children: [
              Icon(Icons.local_offer, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Diskon Rp 10.000 untuk pesanan di atas Rp 50.000',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Daftar produk (bagian yang dimodifikasi)
        Expanded(
          child: ListView.builder(
            itemCount: produkList.length,
            itemBuilder: (context, index) {
              final produk = produkList[index];
              
              // ==========================================================
              // MULAI DARI SINI KITA GANTI MENGGUNAKAN GFCARD
              // ==========================================================
              return InkWell(
              onTap: () { // Fungsi pindah halaman saat kartu di-klik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HalamanDetail(
                        produk: produk,
                        onTambahKeKeranjang: () {
                          onAddToCart(produk);
                        },
                      ),
                    ),
                  );
                },
                child: GFCard(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.zero, // Padding diatur manual di dalam
                elevation: 3,
                boxFit: BoxFit.cover,
                showImage: true,
                image: Image.network( // Gambar besar di bagian atas kartu
                  produk.gambar,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                title: GFListTile(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    produk.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subTitle: Text( // Harga kita letakkan di sini agar lebih menonjol
                    'Rp${produk.harga.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    produk.deskripsi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                buttonBar: GFButtonBar(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  children: <Widget>[
                    GFButton(
                      onPressed: () {
                        onAddToCart(produk); // Fungsi tambah ke keranjang tetap sama
                      },
                      text: 'Tambah ke Keranjang',
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                      color: Colors.orange,
                      blockButton: true, // Tombol memenuhi lebar kartu
                      size: GFSize.LARGE,
                    ),
                  ],
                ),
              )
              );
              // ==========================================================
              // AKHIR DARI PERUBAHAN GFCARD
              // ==========================================================
            },
          ),
        ),
      ],
    );
  }
}
*/ 

/* HALAMAN PROFIL


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';

class HalamanProfil extends StatelessWidget {
  final String email;
  const HalamanProfil({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 2, child: _BagianAtas(email: email)),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Halo, $email',
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
                      label: const Text("Kamu Sudah Melakukan Transaksi"),
                      icon: const Icon(Icons.person_add_alt_1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _BarisInfoProfil(email: email), //
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
        final transactionCount = transactionProvider.transactionsForUser(email).length;
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
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff0043ba), Color(0xff006df1)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'assets/LOGO.png',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
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
*/

/*HALAMAN LOGIN

import 'package:menu_makanan/halaman_password.dart';
import 'package:menu_makanan/halaman_registrasi.dart';
import 'package:flutter/material.dart';
import 'package:menu_makanan/main.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String errorMessage = "";

  void _login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (fakeDatabase.containsKey(email) && fakeDatabase[email] == password) {
      Navigator.pushReplacementNamed(
        context,
        "/main",
        arguments: {"email": email},
      );
    } else {
      setState(() {
        errorMessage = "Email atau password salah!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Silahkan Login",
      fields: Column(
        children: [
          // Email
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              hintText: "Masukkan Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Password
          TextField(
            controller: passwordController,
            obscureText: isPasswordVisible ? false : true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              hintText: "Masukkan Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
          ),

          if (errorMessage.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _login,
              child: const Text("LOGIN"),
            ),
          ),

          // Remember & Forgot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: false, onChanged: (val) {}),
                  const Text("Ingat Saya"),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    animatedRoute(
                      const HalamanLupaPassword(),
                      direction: AxisDirection.left,
                    ),
                  );
                },
                child: const Text("Lupa Password?"),
              ),
            ],
          ),
        ],
      ),

      bottomText: "Belum Punya Akun?",
      bottomButtonText: "Buat Akun",
      onBottomButtonPressed: () {
        Navigator.push(
          context,
          animatedRoute(const HalamanRegistrasi(), direction: AxisDirection.up),
        );
      },
    );
  }
}
*/

/*SPALSHSCREEN

import 'dart:async';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:menu_makanan/halaman_login.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});
  @override
  State <Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animasi fade-in
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // Timer untuk pindah screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        //MaterialPageRoute(builder: (context) => const HalamanLogin()),
         MaterialPageRoute(builder: (context) => const HalamanLogin()), // Ganti sesuai tujuan
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  image: const DecorationImage(
                    image: AssetImage('assets/LOGO.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              //const CircularProgressIndicator(
              // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              // ),
              LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'WARUNG KITA',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Text(
                'By Qolbun Halim Hidayatulloh\n24111814065',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],  
          ),
        ),
      ),
    );
  }
}
*/

/*MAIN DART


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'halaman_registrasi.dart';
import 'package:menu_makanan/halaman_login.dart';
import 'package:menu_makanan/halaman_password.dart';
import 'package:menu_makanan/loading.dart';
import 'package:menu_makanan/mainscreen.dart';
import 'package:menu_makanan/providers/theme_provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi WebView platform untuk Android
  WebViewPlatform.instance = SurfaceAndroidWebView();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}*/


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Warung Kita',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          initialRoute: "/splash",
          routes: {
            "/splash": (context) => const Loading(),
            "/login": (context) => const HalamanLogin(),
            "/register": (context) => const HalamanRegistrasi(),
            "/forgot": (context) => const HalamanLupaPassword(),
            "/main": (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
              final email = args?['email'] ?? '';
              return MainScreen(email: email);
            }
          },
        );
      },
    );
  }
}

// Simulasi database lokal
Map<String, String> fakeDatabase = {};

// ======================================================
// ANIMATED ROUTE (CUSTOM SLIDE TRANSITION)
// ======================================================
Route animatedRoute(
  Widget page, {
  AxisDirection direction = AxisDirection.right,
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      var tween = Tween<Offset>(
        begin: _getBeginOffset(direction),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}

Offset _getBeginOffset(AxisDirection direction) {
  switch (direction) {
    case AxisDirection.up:
      return const Offset(0, 1);
    case AxisDirection.down:
      return const Offset(0, -1);
    case AxisDirection.left:
      return const Offset(1, 0);
    case AxisDirection.right:
      return const Offset(-1, 0);
  }
}

// ======================================================
// AUTH SCAFFOLD (RESPONSIVE LAYOUT)
// ======================================================
class AuthScaffold extends StatelessWidget {
  final String title;
  final Widget fields;
  final String bottomText;
  final String bottomButtonText;
  final VoidCallback onBottomButtonPressed;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.fields,
    required this.bottomText,
    required this.bottomButtonText,
    required this.onBottomButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/buri.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 700;

            return Center(
              child: Container(
                width: isWide ? 800 : double.infinity,
                height: isWide ? 500 : double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  boxShadow: isWide
                      ? [const BoxShadow(color: Colors.black12, blurRadius: 10)]
                      : null,
                  borderRadius: isWide
                      ? BorderRadius.circular(15)
                      : BorderRadius.zero,
                ),
                child: isWide
                    ? Row(
                        children: [
                          _buildFormSection(context),
                          _buildBlueSection(),
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(child: _buildFormSection(context)),
                          _buildBlueSection(),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              fields,
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(bottomText),
                  TextButton(
                    onPressed: onBottomButtonPressed,
                    child: Text(bottomButtonText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlueSection() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  image: const DecorationImage(
                    image: AssetImage('assets/LOGO.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Selamat Datang\nWarung Kita",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/