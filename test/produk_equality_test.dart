import 'package:flutter_test/flutter_test.dart';
import 'package:menu_makanan/features/product/domain/entities/product.dart';

void main() {
  test('Produk equality isolated', () {
    final p1 = Produk(
      id: '1',
      nama: 'Nasi Goreng',
      harga: 20000,
      gambar: 'nasi_goreng.jpg',
      deskripsi: 'Enak',
      rating: 4.5,
      linkWeb: 'https://example.com',
    );
    final p2 = Produk(
      id: '1',
      nama: 'Nasi Goreng',
      harga: 20000,
      gambar: 'nasi_goreng.jpg',
      deskripsi: 'Enak',
      rating: 4.5,
      linkWeb: 'https://example.com',
    );
    
    print('p1: $p1');
    print('p2: $p2');
    print('p1 props: ${p1.props}');
    print('p2 props: ${p2.props}');
    print('p1 == p2: ${p1 == p2}');
    
    expect(p1, p2);
  });
}
