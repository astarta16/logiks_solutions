import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/products_remote_datasource.dart';
import '../../data/products_repository_impl.dart';
import '../../data/product_model.dart';
import '../../../../injection/injection.dart';

final productsDatasourceProvider = Provider(
  (ref) => ProductsRemoteDatasource(sl()),
);

final productsRepositoryProvider = Provider(
  (ref) => ProductsRepositoryImpl(ref.read(productsDatasourceProvider)),
);

class ProductsState {
  final List<ProductModel> products;
  final int? updatedIndex;

  ProductsState({required this.products, this.updatedIndex});

  ProductsState copyWith({List<ProductModel>? products, int? updatedIndex}) {
    return ProductsState(
      products: products ?? this.products,
      updatedIndex: updatedIndex,
    );
  }
}

class ProductsNotifier extends StateNotifier<AsyncValue<ProductsState>> {
  final ProductsRepositoryImpl repository;
  Timer? _timer;

  ProductsNotifier(this.repository) : super(const AsyncLoading()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await repository.getProducts();

      state = AsyncData(ProductsState(products: products));

      _startSimulation();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void _startSimulation() {
    final random = Random();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final currentState = state.value;
      if (currentState == null) return;

      final index = random.nextInt(currentState.products.length);
      final product = currentState.products[index];

      final newData = Map<String, dynamic>.from(product.data ?? {});
      newData['randomValue'] = random.nextInt(100);

      final updatedProduct = ProductModel(
        id: product.id,
        name: product.name,
        data: newData,
      );

      final updatedList = [...currentState.products];
      updatedList[index] = updatedProduct;

      state = AsyncData(
        currentState.copyWith(products: updatedList, updatedIndex: index),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<ProductsState>>(
      (ref) => ProductsNotifier(ref.read(productsRepositoryProvider)),
    );
