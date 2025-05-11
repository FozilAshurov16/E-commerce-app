import 'dart:math';

import 'package:e_commerce_app/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final double totalAmount;
  final DateTime date;
  final List<CartItem> products;
  const OrderItem({
    super.key,
    required this.totalAmount,
    required this.products,
    required this.date,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.totalAmount.toStringAsFixed(2)}"),
            subtitle: Text(
              DateFormat("dd/MM/yyyy hh:mm ").format(widget.date),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: EdgeInsets.all(1),
              height: min(widget.products.length * 20 + 50, 200),
              child: ListView.builder(
                itemExtent: 35,
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      "${product.quantity}x \$${product.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
