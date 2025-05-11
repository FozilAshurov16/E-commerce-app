import 'package:e_commerce_app/providers/orders.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future ordersFuture;
  Future getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    ordersFuture = getOrdersFuture();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Your Orders"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: ordersFuture,
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
              return Consumer<Orders>(
                builder: (context, orders, child) => orders.orders.isEmpty
                    ? const Center(
                        child: Text("No orders yet!"),
                      )
                    : ListView.builder(
                        itemCount: orders.orders.length,
                        itemBuilder: (context, index) {
                          final order = orders.orders[index];
                          return OrderItem(
                            totalAmount: order.totalAmount,
                            date: order.date,
                            products: order.products,
                          );
                        },
                      ),
              );
            } else {
              return const Center(
                child: Text("Something went wrong!"),
              );
            }
          }
        },
      ),
    );
  }
}
