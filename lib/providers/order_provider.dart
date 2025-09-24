import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  OrderProvider(this._firestoreService);

  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final orderData = await _firestoreService.getCollection('orders');
      _orders = orderData
          .where((doc) => doc['userId'] == userId)
          .map((doc) => Order.fromMap('', doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(Order order) async {
    await _firestoreService.saveOrder(order.toMap());
    fetchOrders(order.userId);
  }
}
