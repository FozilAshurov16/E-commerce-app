import 'package:e_commerce_app/providers/cart.dart';
import 'package:e_commerce_app/screens/cart_screen.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/custom_cart.dart';
import 'package:e_commerce_app/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FiltersOptions {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field
  var _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  child: Text(" All Products"),
                  value: FiltersOptions.All,
                ),
                PopupMenuItem(
                  child: Text("Favorites"),
                  value: FiltersOptions.Favorites,
                ),
              ];
            },
            onSelected: (FiltersOptions filter) {
              setState(
                () {
                  if (filter == FiltersOptions.All) {
                    // ignore: void_checks
                    _showFavoritesOnly = false;
                  } else {
                    // ignore: void_checks
                    _showFavoritesOnly = true;
                  }
                },
              );
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => CustomCart(
              // ignore: sort_child_properties_last
              child: child!,
              number: cart.itemsCount().toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(
                Icons.shopping_cart,
                size: 25,
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: const Text(
          "My Store",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(
        _showFavoritesOnly,
      ),
    );
  }
}
