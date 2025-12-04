import 'package:flutter_test/flutter_test.dart';
import 'package:menu_makanan/features/product/data/models/produk_model.dart';

void main() {
  test('minimal model test', () {
    const model = ProdukModel(
      id: '1',
      nama: 'Test',
      deskripsi: 'Desc',
      harga: 10000,
      gambar: 'img.jpg',
      rating: 5.0,
      bahan: ['A'],
      linkWeb: 'http',
    );
    expect(model.id, '1');
  });
}
