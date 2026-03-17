import 'package:logiks_solutions/core/network/api_client.dart';
import 'product_model.dart';

class ProductsRemoteDatasource {
  final ApiClient apiClient;

  ProductsRemoteDatasource(this.apiClient);

  Future<List<ProductModel>> getProducts() async {
    final response = await apiClient.get('objects');

    final List data = response.data;

    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
