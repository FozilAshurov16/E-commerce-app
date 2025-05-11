import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFavorites;

  const ProductsGrid(this.showFavorites, {super.key});

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  late Future productsFuture;

  Future getProductsFuture() async {
    return Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  void initState() {
    productsFuture = getProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productsFuture,
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(
                255,
                248,
                204,
                102,
              ),
            ),
          );
        } else {
          if (dataSnapshot.error == null) {
            return Consumer<Products>(
              builder: (context, products, child) {
                final ps =
                    widget.showFavorites ? products.favorites : products.list;
                return ps.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(17.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: ps.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider<Product>.value(
                            value: ps[index],
                            child: ProductItem(),
                          );
                        },
                      )
                    : const Center(
                        child: Text('No products found'),
                      );
              },
            );
          } else {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
        }
      },
    );
  }
}
