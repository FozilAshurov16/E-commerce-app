import 'package:e_commerce_app/models/cart_item.dart';

class Order {
  final String id;
  final double totalAmount;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.totalAmount,
    required this.products,
    required this.date,
  });
}
