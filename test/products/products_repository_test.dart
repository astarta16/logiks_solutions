import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:logiks_solutions/features/products/data/products_repository_impl.dart';
import 'package:logiks_solutions/features/products/data/products_remote_datasource.dart';
import 'package:logiks_solutions/features/products/data/product_model.dart';

class MockDatasource extends Mock implements ProductsRemoteDatasource {}

void main() {
  late ProductsRepositoryImpl repository;
  late MockDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockDatasource();
    repository = ProductsRepositoryImpl(mockDatasource);
  });

  final mockProducts = [ProductModel(id: '1', name: 'Test Product', data: {})];

  group('ProductsRepository Tests', () {
    test('should return list of products from datasource', () async {
      when(
        () => mockDatasource.getProducts(),
      ).thenAnswer((_) async => mockProducts);

      final result = await repository.getProducts();

      expect(result, mockProducts);
      verify(() => mockDatasource.getProducts()).called(1);
    });
  });
}
