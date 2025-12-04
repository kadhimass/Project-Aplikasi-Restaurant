import 'package:flutter_test/flutter_test.dart';
import 'package:menu_makanan/features/product/data/datasources/dummydata.dart';

void main() {
  test('debug dummy data', () {
    final list = DummyData.getProdukList();
    expect(list.isNotEmpty, true);
  });
}
