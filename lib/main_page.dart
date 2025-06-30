import 'package:flutter/material.dart';
import 'staff_form_dialog.dart';
import 'staff_list_page.dart';
import 'theme_constants.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.deepPurple.shade900,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Insert your image here
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Image.asset(
                    'assets/image.png',
                    height: 110, // Adjust size as needed
                  ),
                ),
                const Text(
                  'Staff Registration',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'This app is a lab test to demonstrate Firebase CRUD (Create, Read, Update, Delete) functionality for managing staff.',
                  style: TextStyle(fontSize: 14.5, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Designed by: awatifbdn,  D20221101814',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  onPressed: () => showStaffFormDialog(context, isEdit: false),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Staff'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StaffListPage()),
                    );
                  },
                  child: const Text('View Staff List'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple.shade700,
                    side: BorderSide(color: Colors.deepPurple.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
