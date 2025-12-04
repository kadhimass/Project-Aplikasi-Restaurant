import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:menu_makanan/providers/theme_provider.dart';
import 'package:menu_makanan/providers/transaction_provider.dart';
import 'package:menu_makanan/providers/payment_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';

import 'package:menu_makanan/router/app_router.dart';
import 'package:menu_makanan/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:menu_makanan/features/product/presentation/cubit/produk_cubit.dart';
import 'package:menu_makanan/features/product/data/datasources/produk_remote_datasource.dart';
import 'package:menu_makanan/features/product/data/datasources/produk_local_datasource.dart';
import 'package:menu_makanan/features/product/data/repositories/produk_repository_impl.dart';
import 'package:menu_makanan/features/product/domain/usecases/get_all_produk_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/search_produk_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/get_minuman_usecase.dart';
import 'package:menu_makanan/features/product/domain/usecases/search_minuman_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Setup Dio
  final dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));

  // Setup Dependency Injection
  final produkRemoteDataSource = ProdukRemoteDataSourceImpl(dio: dio);
  final produkLocalDataSource = ProdukLocalDataSourceImpl();
  final produkRepository = ProdukRepositoryImpl(
    remoteDataSource: produkRemoteDataSource,
    localDataSource: produkLocalDataSource,
  );
  
  final getAllProdukUseCase = GetAllProdukUseCase(produkRepository);
  final searchProdukUseCase = SearchProdukUseCase(produkRepository);
  final getMinumanUseCase = GetMinumanUseCase(produkRepository);
  final searchMinumanUseCase = SearchMinumanUseCase(produkRepository);

  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TransactionProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => PaymentProvider()),
            BlocProvider(create: (_) => CartBloc()),
            BlocProvider(
              create: (_) => ProdukCubit(
                getAllProdukUseCase: getAllProdukUseCase,
                searchProdukUseCase: searchProdukUseCase,
                getMinumanUseCase: getMinumanUseCase,
                searchMinumanUseCase: searchMinumanUseCase,
              ),
            ),
          ],
          child: const MyApp(),
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

Map<String, String> fakeDatabase = {
  'user': '123', // Default account
};

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
