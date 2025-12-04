import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:menu_makanan/core/errors/failures.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';
import 'package:menu_makanan/features/product/domain/repositories/produk_repository.dart';
import 'package:menu_makanan/features/product/domain/usecases/search_produk_usecase.dart';

class MockProdukRepository extends Mock implements ProdukRepository {}

void main() {
  late SearchProdukUseCase usecase;
  late MockProdukRepository mockProdukRepository;

  setUp(() {
    mockProdukRepository = MockProdukRepository();
    usecase = SearchProdukUseCase(mockProdukRepository);
  });

  final tProdukList = [
    Produk(
      id: '1',
      nama: 'Nasi Goreng',
      harga: 20000,
      gambar: 'nasi_goreng.jpg',
      deskripsi: 'Enak',
      rating: 4.5,
      linkWeb: 'https://example.com',
    ),
  ];
  const tQuery = 'Nasi';

  test('should get list of products from the repository when searching', () async {
    // arrange
    when(() => mockProdukRepository.searchProduk(tQuery))
        .thenAnswer((_) async => Right<Failure, List<Produk>>(tProdukList));

    // act
    final result = await usecase(tQuery);

    // assert
    expect(result, Right(tProdukList));
    verify(() => mockProdukRepository.searchProduk(tQuery)).called(1);
    verifyNoMoreInteractions(mockProdukRepository);
  });
}
