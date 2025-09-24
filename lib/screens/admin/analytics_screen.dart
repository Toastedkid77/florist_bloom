import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchAnalyticsData() async {
    final ordersSnapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    double totalRevenue = 0.0;
    for (var doc in ordersSnapshot.docs) {
      final order = doc.data();
      totalRevenue += order['totalAmount'] ?? 0.0;
    }

    return {
      'totalRevenue': totalRevenue,
      'totalOrders': ordersSnapshot.docs.length,
      'totalUsers': usersSnapshot.docs.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchAnalyticsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.pink));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? {};
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildAnalyticsCard(
                  title: 'Total Revenue',
                  value:
                      '\$${data['totalRevenue']?.toStringAsFixed(2) ?? '0.00'}',
                ),
                _buildAnalyticsCard(
                  title: 'Total Orders',
                  value: '${data['totalOrders'] ?? 0}',
                ),
                _buildAnalyticsCard(
                  title: 'Total Users',
                  value: '${data['totalUsers'] ?? 0}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsCard({required String title, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text(value,
            style: const TextStyle(fontSize: 18, color: Colors.pink)),
      ),
    );
  }
}
