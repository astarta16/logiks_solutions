import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  int? expandedIndex;

  final ScrollController _scrollController = ScrollController();
  List<GlobalKey> itemKeys = [];

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsState.when(
        data: (stateData) {
          final products = stateData.products;
          final updatedIndex = stateData.updatedIndex;

          if (itemKeys.length != products.length) {
            itemKeys = List.generate(products.length, (_) => GlobalKey());
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isExpanded = expandedIndex == index;

              return Container(
                key: itemKeys[index],
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text('${product.id} - ${product.name}'),
                          ),

                          if (updatedIndex == index && expandedIndex != index)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                        onPressed: () {
                          setState(() {
                            expandedIndex = isExpanded ? null : index;
                          });

                          if (!isExpanded) {
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                final context = itemKeys[index].currentContext;

                                if (context != null) {
                                  Scrollable.ensureVisible(
                                    context,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),

                    if (isExpanded)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: updatedIndex == index
                            ? Colors.yellow.shade200
                            : Colors.grey.shade200,
                        child: Text(product.data?.toString() ?? 'No details'),
                      ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
