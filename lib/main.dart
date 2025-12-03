import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_makanan/bloc/cart_bloc.dart';
import 'package:menu_makanan/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:menu_makanan/providers/theme_provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:menu_makanan/providers/payment_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (context) => CartBloc())],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => ThemeProvider()),
              ChangeNotifierProvider(
                create: (context) => TransactionProvider(),
              ),
              ChangeNotifierProvider(create: (context) => PaymentProvider()),
            ],
            child: const MyApp(),
          ),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createAppRouter();

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Warung Kita',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            brightness: Brightness.light,
            // Tambahan untuk mobile
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routerConfig: router,
        );
      },
    );
  }
}

Map<String, String> fakeDatabase = {};

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
        child: SafeArea(
          // SafeArea untuk menghindari notch dan status bar
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;

              return Padding(
                padding: isMobile
                    ? const EdgeInsets.all(16.0)
                    : const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    width: isMobile ? double.infinity : 800,
                    height: isMobile ? null : 500, // Auto height untuk mobile
                    constraints: isMobile
                        ? const BoxConstraints(maxWidth: 400)
                        : const BoxConstraints(),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.95,
                      ), // Sedikit lebih opaque untuk mobile
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: isMobile ? 5 : 10,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(isMobile ? 12 : 15),
                    ),
                    child: isMobile
                        ? _buildMobileLayout(context)
                        : _buildDesktopLayout(context),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header section untuk mobile
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/LOGO.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Warung Kita",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Form section untuk mobile
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20, // Sedikit lebih kecil untuk mobile
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                fields,
                const SizedBox(height: 20),
                _buildBottomTextRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(children: [_buildFormSection(context), _buildOrangeSection()]);
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
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              fields,
              const SizedBox(height: 20),
              _buildBottomTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTextRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          bottomText,
          style: const TextStyle(fontSize: 14),
          selectionColor: Colors.black,
        ),
        TextButton(
          onPressed: onBottomButtonPressed,
          child: Text(
            bottomButtonText,
            style: const TextStyle(fontSize: 14),
            selectionColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildOrangeSection() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.orangeAccent],
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
