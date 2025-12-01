import 'package:flutter/material.dart';
import 'package:sitelogger/features/const/SafetyIssue.dart';
import 'package:sitelogger/features/const/StorageService.dart';

class AddIssueDialog extends StatefulWidget {
  final VoidCallback onIssueAdded;

  const AddIssueDialog({super.key, required this.onIssueAdded});

  @override
  State<AddIssueDialog> createState() => _AddIssueDialogState();
}

class _AddIssueDialogState extends State<AddIssueDialog> {
  final _descriptionController = TextEditingController();
  String _selectedSeverity = 'Medium';
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitIssue() async {
    if (_formKey.currentState!.validate()) {
      final issue = SafetyIssue(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descriptionController.text.trim(),
        severity: _selectedSeverity,
        status: 'Pending',
        timestamp: DateTime.now(),
        reportedBy: 'staff@gmail.com',
      );

      await StorageService.addIssue(issue);
      widget.onIssueAdded();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Safety issue logged successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Safety Issue'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Issue Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Severity',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warning),
              ),
              items: ['Low', 'Medium', 'High'].map((severity) {
                return DropdownMenuItem(
                  value: severity,
                  child: Text(severity),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSeverity = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitIssue,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text('Submit', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

