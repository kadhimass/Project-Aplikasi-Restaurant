import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/exceptions.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/product/data/datasources/produk_local_datasource.dart';
import 'package:menu_makanan/features/product/data/datasources/produk_remote_datasource.dart';
import 'package:menu_makanan/features/product/data/models/produk_model.dart';
import 'package:menu_makanan/features/product/data/repositories/produk_repository_impl.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';

class MockProdukRemoteDataSource extends Mock implements ProdukRemoteDataSource {}
class MockProdukLocalDataSource extends Mock implements ProdukLocalDataSource {}

void main() {
  late ProdukRepositoryImpl repository;
  late MockProdukRemoteDataSource mockRemoteDataSource;
  late MockProdukLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockProdukRemoteDataSource();
    mockLocalDataSource = MockProdukLocalDataSource();
    repository = ProdukRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tProdukModel = ProdukModel(
    id: '1',
    nama: 'Nasi Goreng',
    harga: 20000,
    gambar: 'nasi_goreng.jpg',
    deskripsi: 'Enak',
    rating: 4.5,
    bahan: ['Nasi'],
    linkWeb: 'https://example.com',
  );

  final tProdukModelList = [tProdukModel];
  final List<Produk> tProdukList = tProdukModelList;

  group('getAllProduk', () {
    test('should return remote data when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.searchProduk(''))
          .thenAnswer((_) async => tProdukModelList);

      // act
      final result = await repository.getAllProduk();

      // assert
      verify(() => mockRemoteDataSource.searchProduk(''));
      expect(result, equals(Right(tProdukList)));
    });

    test('should return server failure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(() => mockRemoteDataSource.searchProduk(''))
          .thenThrow(ServerException());

      // act
      final result = await repository.getAllProduk();

      // assert
      verify(() => mockRemoteDataSource.searchProduk(''));
      expect(result, equals(Left(ServerFailure('Server Error'))));
    });
  });

  group('getProdukById', () {
    final tId = '1';

    test('should return local data when the call to local data source is successful', () async {
      // arrange
      when(() => mockLocalDataSource.getProdukById(tId))
          .thenAnswer((_) async => tProdukModel);

      // act
      final result = await repository.getProdukById(tId);

      // assert
      verify(() => mockLocalDataSource.getProdukById(tId));
      expect(result, equals(Right(tProdukModel)));
    });

    test('should return cache failure when the call to local data source is unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.getProdukById(tId))
          .thenThrow(Exception());

      // act
      final result = await repository.getProdukById(tId);

      // assert
      verify(() => mockLocalDataSource.getProdukById(tId));
      expect(result, equals(Left(CacheFailure('Product not found'))));
    });
  });
}
