import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService;

  ProductProvider(this._productService);

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    await _productService.addProduct(product);
    fetchProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _productService.updateProduct(product);
    fetchProducts();
  }

  Future<void> deleteProduct(String productId) async {
    await _productService.deleteProduct(productId);
    fetchProducts();
  }
}
