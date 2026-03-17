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
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: productsState.when(
            data: (stateData) {
              final products = stateData.products;
              final updatedIndex = stateData.updatedIndex;

              if (itemKeys.length != products.length) {
                itemKeys = List.generate(products.length, (_) => GlobalKey());
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isExpanded = expandedIndex == index;

                  return Container(
                    key: itemKeys[index],
                    margin: const EdgeInsets.only(bottom: 14),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              if (updatedIndex == index &&
                                  expandedIndex != index)
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            'ID: ${product.id}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),

                          trailing: AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: const Icon(Icons.keyboard_arrow_down),
                          ),

                          onTap: () {
                            setState(() {
                              expandedIndex = isExpanded ? null : index;
                            });

                            if (!isExpanded) {
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  final context =
                                      itemKeys[index].currentContext;

                                  if (context != null) {
                                    Scrollable.ensureVisible(
                                      context,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),

                        AnimatedCrossFade(
                          firstChild: const SizedBox(),
                          secondChild: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: updatedIndex == index
                                  ? Colors.yellow.shade100
                                  : const Color(0xFFF9FAFB),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(18),
                              ),
                            ),
                            child: Text(
                              product.data?.toString() ?? 'No details',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 250),
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
        ),
      ),
    );
  }
}
