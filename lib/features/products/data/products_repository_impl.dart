import 'package:logiks_solutions/features/products/domain/products_repository.dart';
import 'products_remote_datasource.dart';
import 'product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDatasource datasource;

  ProductsRepositoryImpl(this.datasource);

  @override
  Future<List<ProductModel>> getProducts() async {
    return await datasource.getProducts();
  }
}
