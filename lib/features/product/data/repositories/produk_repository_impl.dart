import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/core/errors/exceptions.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/features/product/domain/repositories/produk_repository.dart';
import 'package:menu_makanan/features/product/data/datasources/produk_remote_datasource.dart';
import 'package:menu_makanan/features/product/data/datasources/produk_local_datasource.dart';

class ProdukRepositoryImpl implements ProdukRepository {
  final ProdukRemoteDataSource remoteDataSource;
  final ProdukLocalDataSource localDataSource;

  ProdukRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Produk>>> getAllProduk() async {
    try {
      final result = await remoteDataSource.searchProduk('');
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Produk>> getProdukById(String id) async {
    try {
      final result = await localDataSource.getProdukById(id);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure('Product not found'));
    }
  }

  @override
  Future<Either<Failure, List<Produk>>> searchProduk(String query) async {
    try {
      final result = await remoteDataSource.searchProduk(query);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Produk>>> getMinuman() async {
    try {
      final result = await remoteDataSource.getMinuman();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Produk>>> searchMinuman(String query) async {
    try {
      final result = await remoteDataSource.searchMinuman(query);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
