import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data?.docs ?? [];
          final admins = users
              .where((doc) =>
                  (doc.data() as Map<String, dynamic>)['role'] == 'admin')
              .toList();
          final customers = users
              .where((doc) =>
                  (doc.data() as Map<String, dynamic>)['role'] == 'customer')
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (admins.isNotEmpty)
                _buildUserSection('Admins', admins, context),
              if (customers.isNotEmpty)
                _buildUserSection('Customers', customers, context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserSection(
      String title, List<QueryDocumentSnapshot> users, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final userId = users[index].id;

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: Text(
                    userData['name']?.substring(0, 1).toUpperCase() ?? '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  userData['name'] ?? 'No Name',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Email: ${userData['email']}'),
                trailing: Text(
                  userData['role']?.toUpperCase() ?? 'ROLE',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  _showUserActions(context, userId, userData);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _showUserActions(
      BuildContext context, String userId, Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.pink),
                title: const Text('Edit Role'),
                onTap: () {
                  Navigator.pop(context);
                  _editUserRole(context, userId, userData);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete User'),
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User deleted successfully')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editUserRole(
      BuildContext context, String userId, Map<String, dynamic> userData) {
    final _roleController = TextEditingController(text: userData['role']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User Role'),
          content: TextField(
            controller: _roleController,
            decoration:
                const InputDecoration(labelText: 'Role (admin or customer)'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newRole = _roleController.text.trim();
                if (newRole.isNotEmpty &&
                    (newRole == 'admin' || newRole == 'customer')) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({
                    'role': newRole,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Role updated successfully')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Invalid role! Use "admin" or "customer"')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
