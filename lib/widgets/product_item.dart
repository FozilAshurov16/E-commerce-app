import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/providers/auth.dart';
import 'package:e_commerce_app/providers/cart.dart';
import 'package:e_commerce_app/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, pro, child) {
              return IconButton(
                icon: Icon(
                  pro.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Color.fromARGB(
                  255,
                  248,
                  204,
                  102,
                ),
                onPressed: () {
                  pro.toggleFavorite(auth.token, auth.userId);
                },
              );
            },
          ),
          title: Text(
            textAlign: TextAlign.center,
            product.title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            color: Color.fromARGB(
              255,
              248,
              204,
              102,
            ),
            onPressed: () {
              cart.addToCart(
                product.id,
                product.imageUrl,
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Added to cart!"),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: "UNDO",
                    textColor: Color.fromARGB(
                      255,
                      248,
                      204,
                      102,
                    ),
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
          ),
        ),
      ),
    );
  }
}
