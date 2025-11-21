
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';

class AddLeadScreen extends StatefulWidget { 
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String _email = '';
  String _notes = '';

  void _saveLead() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newLead = Lead(
        name: _name,
        phone: _phone,
        email: _email,
        notes: _notes,
        status: LeadStatus.New, 
      );

      
      await Provider.of<LeadProvider>(context, listen: false).addLead(newLead);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lead added successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      appBar: AppBar(
        title: const Text('Add New Lead'),
      
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                label: 'Full Name',
                hint: 'e.g., Shravani Gudhate',
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                label: 'Phone Number',
                hint: '+91 9503787533',
                onSaved: (value) => _phone = value!,
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                label: 'Email Address',
                hint: 'email@example.com',
                onSaved: (value) => _email = value!,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Email is required' : null,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                label: 'Notes / Description',
                hint: 'Add any relevant notes or details about this lead...',
                onSaved: (value) => _notes = value!,
                maxLines: 5,
                isOptional: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Optional: Add context or important details about this lead',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(height: 40),



             




              ElevatedButton.icon(
                onPressed: _saveLead,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.save),
                label: const Text('Save Lead', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String hint,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ${isOptional ? '' : '*'}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onSaved: onSaved,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }
}