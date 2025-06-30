import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showStaffFormDialog(
  BuildContext context, {
  String? docId,
  String? initialName,
  String? initialId,
  int? initialAge,
  required bool isEdit,
}) {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: initialName);
  final idController = TextEditingController(text: initialId);
  final ageController = TextEditingController(text: initialAge?.toString());

  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEDEBFF), Color(0xFFFFF0E6), Color(0xFFFFF5FB)],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? 'Edit Staff' : 'Add Staff',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration('Name'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: idController,
                  decoration: _inputDecoration('ID Staff'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter staff ID'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  decoration: _inputDecoration('Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Enter age';
                    final age = int.tryParse(value);
                    if (age == null || age <= 0) return 'Enter valid age';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final name = nameController.text.trim();
                          final staffId = idController.text.trim();
                          final age = int.parse(ageController.text.trim());

                          final ref = FirebaseFirestore.instance.collection(
                            'staffs',
                          );

                          try {
                            final navigator = Navigator.of(context);
                            final scaffoldContext = context;

                            if (isEdit && docId != null) {
                              await ref.doc(docId).update({
                                'name': name,
                                'staffId': staffId,
                                'age': age,
                              });

                              navigator.pop(); // close dialog
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  ScaffoldMessenger.of(
                                    scaffoldContext,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text('Staff updated'),
                                    ),
                                  );
                                },
                              );
                            } else {
                              await ref.add({
                                'name': name,
                                'staffId': staffId,
                                'age': age,
                                'timestamp': FieldValue.serverTimestamp(),
                              });

                              navigator.pop(); // close dialog
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  ScaffoldMessenger.of(
                                    scaffoldContext,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text('Staff added'),
                                    ),
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            Navigator.pop(context); // close dialog if error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      child: Text(isEdit ? 'Update' : 'Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    fillColor: Colors.white.withOpacity(0.8),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}
