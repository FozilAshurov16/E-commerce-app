import 'package:e_commerce_app/providers/products.dart';
import 'package:e_commerce_app/screens/edit_product_screen.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  static const routeName = "/manage-product-screen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Manage Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          } else if (snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              color: Color.fromARGB(
                255,
                248,
                204,
                102,
              ),
              onRefresh: () => _refreshProducts(context),
              child: Consumer<Products>(
                builder: (context, productProvider, _) => ListView.builder(
                  itemCount: productProvider.list.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.list[index];
                    return ChangeNotifierProvider.value(
                      value: product,
                      child: const UserProductItem(),
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Something went wrong!"),
            );
          }
        },
      ),
    );
  }
}
