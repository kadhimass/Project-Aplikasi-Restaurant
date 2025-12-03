import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/exceptions.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/produk/data/datasources/produk_remote_datasource.dart';
import 'package:menu_makanan/features/produk/domain/entities/produk_entity.dart';
import 'package:menu_makanan/features/produk/domain/repositories/produk_repository.dart';

class ProdukRepositoryImpl implements ProdukRepository {
  final ProdukRemoteDataSource remoteDataSource;

  ProdukRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProdukEntity>>> getAllProduk() async {
    try {
      final result = await remoteDataSource.searchProduk('');
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } catch (e) {
      return Left(ConnectionFailure('Connection Error'));
    }
  }

  @override
  Future<Either<Failure, ProdukEntity>> getProdukById(String id) {
    // TODO: implement getProdukById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProdukEntity>>> searchProduk(String query) async {
    try {
      final result = await remoteDataSource.searchProduk(query);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } catch (e) {
      return Left(ConnectionFailure('Connection Error'));
    }
  }

  @override
  Future<Either<Failure, List<ProdukEntity>>> getMinuman() async {
    try {
      final result = await remoteDataSource.getMinuman();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } catch (e) {
      return Left(ConnectionFailure('Connection Error'));
    }
  }

  @override
  Future<Either<Failure, List<ProdukEntity>>> searchMinuman(String query) async {
    try {
      final result = await remoteDataSource.searchMinuman(query);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Server Error'));
    } catch (e) {
      debugPrint('Error in getMinuman: $e');
      return Left(ConnectionFailure('Connection Error: $e'));
    }
  }
}
