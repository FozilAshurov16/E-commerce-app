import 'package:e_commerce_app/providers/cart.dart';
import 'package:e_commerce_app/providers/orders.dart';
import 'package:e_commerce_app/screens/orders_screen.dart';
import 'package:e_commerce_app/widgets/cart_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Cart1"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        shape: StadiumBorder(),
                        label: Text(
                          "\$${cart.totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Color.fromARGB(
                          255,
                          248,
                          204,
                          102,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OrderButton(cart: cart),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.toList()[index];
                return CartListItem(
                  productId: cart.items.keys.toList()[index],
                  imageUrl: cartItem.image,
                  title: cartItem.title,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  // ignore: unused_field
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30),
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
          horizontal: 12,
          vertical: 8,
        ),
      ),
      onPressed: (widget.cart.items.isEmpty || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addToOrders(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Color.fromARGB(
                255,
                248,
                204,
                102,
              ),
            )
          : const Text(
              "ORDER NOW",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
    );
  }
}
