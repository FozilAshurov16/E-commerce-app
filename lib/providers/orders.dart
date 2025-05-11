import 'dart:convert';
import 'package:e_commerce_app/models/cart_item.dart';
import 'package:e_commerce_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  String? _authToken;
  String? _userId;

  List<Order> get orders {
    return [..._orders];
  }

  void setParams(String? token, String? userId) {
    _authToken = token;
    _userId = userId;
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        "https://fir-app-4e577-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken");
    try {
      final response = await http.get(url);
      final List<Order> loadedOrders = [];
      // ignore: unnecessary_null_comparison
      if (jsonDecode(response.body) == null) {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach(
        (key, value) {
          loadedOrders.add(
            Order(
              id: key,
              date: DateTime.parse(value["date"]),
              totalAmount: value["amount"],
              products: (value["products"] as List<dynamic>)
                  .map(
                    (product) => CartItem(
                      id: product["id"],
                      title: product["title"],
                      quantity: product["quantity"],
                      price: product["price"],
                      image: product["image"],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addToOrders(List<CartItem> products, double totalAmount) async {
    final url = Uri.parse(
        "https://fir-app-4e577-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "amount": totalAmount,
            "date": DateTime.now().toIso8601String(),
            "products": products
                .map((product) => {
                      "id": product.id,
                      "title": product.title,
                      "image": product.image,
                      "price": product.price,
                      "quantity": product.quantity,
                    })
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        Order(
          id: json.decode(response.body)["name"],
          products: products,
          totalAmount: totalAmount,
          date: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
