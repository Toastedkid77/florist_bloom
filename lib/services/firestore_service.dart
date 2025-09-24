import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create or update a document
  Future<void> setDocument(String path, Map<String, dynamic> data) async {
    final ref = _db.doc(path);
    await ref.set(data, SetOptions(merge: true));
  }

  // Get a document
  Future<Map<String, dynamic>> getDocument(String path) async {
    final ref = _db.doc(path);
    final snapshot = await ref.get();
    return snapshot.data() as Map<String, dynamic>;
  }

  // Delete a document
  Future<void> deleteDocument(String path) async {
    final ref = _db.doc(path);
    await ref.delete();
  }

  // Save an order to Firestore
  Future<void> saveOrder(Map<String, dynamic> orderData) async {
    try {
      await _db.collection('orders').add(orderData); // Save the order
    } catch (e) {
      throw Exception('Failed to save order: $e');
    }
  }

  // Get a collection
  Future<List<Map<String, dynamic>>> getCollection(String path) async {
    final ref = _db.collection(path);
    final snapshot = await ref.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
