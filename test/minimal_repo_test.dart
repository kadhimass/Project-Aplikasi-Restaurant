import 'package:flutter_test/flutter_test.dart';
import 'package:menu_makanan/features/product/data/repositories/produk_repository_impl.dart';
import 'package:menu_makanan/features/product/data/datasources/produk_remote_datasource.dart';
import 'package:menu_makanan/features/product/data/datasources/produk_local_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements ProdukRemoteDataSource {}
class MockLocal extends Mock implements ProdukLocalDataSource {}

void main() {
  test('minimal repo test', () {
    final remote = MockRemote();
    final local = MockLocal();
    final repo = ProdukRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
    );
    expect(repo, isNotNull);
  });
}
