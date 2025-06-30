import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_form_dialog.dart';
import 'theme_constants.dart';

class StaffListPage extends StatelessWidget {
  const StaffListPage({super.key});

  void _deleteStaff(BuildContext context, String id) async {
    await FirebaseFirestore.instance.collection('staffs').doc(id).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Staff deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Staff'),
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.deepPurple.shade900,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('staffs')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No staff records yet.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: docs.length,
                    itemBuilder: (_, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "ID: ${data['staffId']}",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "Age: ${data['age']}",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () => showStaffFormDialog(
                                context,
                                isEdit: true,
                                docId: doc.id,
                                initialName: data['name'],
                                initialId: data['staffId'],
                                initialAge: data['age'],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _deleteStaff(context, doc.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
