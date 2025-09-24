import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  List<CartItem> get cartItems => _items.values.toList();

  double get totalAmount {
    return _items.values
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(Map<String, dynamic> productData) {
    final productId = productData['id'];
    if (_items.containsKey(productId)) {
      // If item already exists, increase quantity
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          name: productData['name'],
          price: productData['price'],
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    final productId = cartItem.id;
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) {
          if (existingItem.quantity > 1) {
            return CartItem(
              id: existingItem.id,
              name: existingItem.name,
              price: existingItem.price,
              quantity: existingItem.quantity - 1,
            );
          }
          return existingItem; // Retain the item if quantity > 1
        },
      );
      if (_items[productId]?.quantity == 1) {
        _items.remove(productId); // Remove item if quantity becomes 1
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
