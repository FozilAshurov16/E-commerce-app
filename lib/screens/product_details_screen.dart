import 'package:e_commerce_app/providers/cart.dart';
import 'package:e_commerce_app/providers/products.dart';
import 'package:e_commerce_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
  });

  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final productId = ModalRoute.of(context)!.settings.arguments;
    final productsData = Provider.of<Products>(context, listen: false)
        .findById(productId as String);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          productsData.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 293,
              width: double.infinity,
              child: Image.network(
                productsData.imageUrl,
                // fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                productsData.description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        color: Colors.grey.shade50,
        height: 105,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color.fromARGB(221, 52, 50, 50),
                    ),
                  ),
                  Text(
                    "\$${productsData.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Consumer<Cart>(
              builder: (context, cart, child) {
                final isProductAdded = cart.items.containsKey(productId);
                if (isProductAdded) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      side: BorderSide(
                        color: const Color.fromARGB(
                          255,
                          248,
                          204,
                          102,
                        ),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed(
                      CartScreen.routeName,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Color.fromARGB(
                            255,
                            248,
                            204,
                            102,
                          ),
                          size: 25,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        const Text(
                          "Go to Cart",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(
                              255,
                              248,
                              204,
                              102,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                        255,
                        248,
                        204,
                        102,
                      ),
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () => cart.addToCart(
                      productId,
                      productsData.imageUrl,
                      productsData.price,
                      productsData.title,
                    ),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
