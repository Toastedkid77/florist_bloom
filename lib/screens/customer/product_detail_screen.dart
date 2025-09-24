import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({Key? key, required this.productData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productData['name'] ?? 'Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            productData['imageUrl'] != null
                ? Image.network(productData['imageUrl'], height: 200)
                : const Icon(Icons.image, size: 200, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              productData['name'] ?? 'No Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${productData['price']?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(fontSize: 20, color: Colors.pink),
            ),
            const SizedBox(height: 20),
            Text(
              productData['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().addItem(productData);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart!')),
                );
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
