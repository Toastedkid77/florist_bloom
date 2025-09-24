import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const CartItem({
    required this.product,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(product.name),
      subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onRemove,
      ),
    );
  }
}
