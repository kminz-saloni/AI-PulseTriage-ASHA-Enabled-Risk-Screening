import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EmergencyCreateScreen extends ConsumerStatefulWidget {
  final String? patientId;

  const EmergencyCreateScreen({
    super.key,
    this.patientId,
  });

  @override
  ConsumerState<EmergencyCreateScreen> createState() => _EmergencyCreateScreenState();
}

class _EmergencyCreateScreenState extends ConsumerState<EmergencyCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'High';

  @override
  void dispose() {
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Emergency'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(Icons.warning, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Emergency Type',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'High', child: Text('High')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                DropdownMenuItem(value: 'Low', child: Text('Low')),
              ],
              onChanged: (value) {
                setState(() {
                  _priority = value ?? 'High';
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createEmergency,
              icon: const Icon(Icons.save),
              label: const Text('Create Emergency'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createEmergency() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency alert created')),
      );
      context.pop();
    }
  }
}
