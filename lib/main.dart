
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
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await initializeDateFormatting('id_ID', null);
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
