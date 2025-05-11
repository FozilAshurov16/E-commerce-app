import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _list = [];

  List<Product> get list {
    return [..._list];
  }

  String? _authToken;
  String? _userId;

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
    notifyListeners();
  }

  List<Product> get favorites {
    return _list.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        "https://fir-app-4e577-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString");
    try {
      final response = await http.get(url);

      if (json.decode(response.body) != null) {
        final favoritesUrl = Uri.parse(
          "https://fir-app-4e577-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken",
        );
        final favoritesResponse = await http.get(favoritesUrl);
        final favoriteData = json.decode(favoritesResponse.body);

        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        final List<Product> loadedProducts = [];
        extractedData.forEach(
          (key, value) {
            loadedProducts.add(
              Product(
                id: key,
                title: value["title"],
                description: value["description"],
                price: value["price"],
                imageUrl: value["imageUrl"],
                isFavorite:
                    favoriteData == null ? false : favoriteData[key] ?? false,
              ),
            );
          },
        );
        _list = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      print('Error in fetchProducts: $error');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://fir-app-4e577-default-rtdb.firebaseio.com/products.json?auth=$_authToken");

    try {
      print('Sending request to add product with token: $_authToken');
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "creatorId": _userId
          },
        ),
      );

      print('Add product response status: ${response.statusCode}');
      print('Add product response body: ${response.body}');

      if (response.statusCode >= 400) {
        throw HttpException(
            'Failed to add product. Status code: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      if (responseData == null || responseData['name'] == null) {
        throw HttpException('Invalid response from server');
      }

      final name = responseData["name"];
      final newProduct = Product(
        id: name,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );

      _list.add(newProduct);
      notifyListeners();
      print('Product successfully added with ID: $name');
    } catch (error) {
      print('Error in addProduct: $error');
      rethrow;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final productIndex = _list.indexWhere(
      (product) => product.id == updatedProduct.id,
    );
    if (productIndex >= 0) {
      final url = Uri.parse(
          "https://fir-app-4e577-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json?auth=$_authToken");
      try {
        final response = await http.patch(
          url,
          body: jsonEncode(
            {
              "title": updatedProduct.title,
              "description": updatedProduct.description,
              "price": updatedProduct.price,
              "imageUrl": updatedProduct.imageUrl,
            },
          ),
        );

        if (response.statusCode >= 400) {
          throw HttpException('Failed to update product');
        }

        _list[productIndex] = updatedProduct;
        notifyListeners();
      } catch (error) {
        print('Error in updateProduct: $error');
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://fir-app-4e577-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken");

    try {
      var deletingProduct = _list.firstWhere((product) => product.id == id);
      final productIndex = _list.indexWhere((product) => product.id == id);
      _list.removeWhere((product) => product.id == id);
      notifyListeners();

      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _list.insert(
          productIndex,
          deletingProduct,
        );
        notifyListeners();
        throw HttpException("Failed to delete product");
      }
    } catch (error) {
      print('Error in deleteProduct: $error');
      rethrow;
    }
  }

  Product findById(String productId) {
    return _list.firstWhere((product) => product.id == productId);
  }
}
