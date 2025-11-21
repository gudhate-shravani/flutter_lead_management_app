
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';

class EditLeadScreen extends StatefulWidget {
  final Lead lead;
  const EditLeadScreen({super.key, required this.lead});

  @override
  State<EditLeadScreen> createState() => _EditLeadScreenState();
}

class _EditLeadScreenState extends State<EditLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late String _email;
  late String _notes;

  @override
  void initState() {
    super.initState();
    
    _name = widget.lead.name;
    _phone = widget.lead.phone;
    _email = widget.lead.email;
    _notes = widget.lead.notes;
  }

  void _updateLead() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final updatedLead = widget.lead.copyWith(
        name: _name,
        phone: _phone,
        email: _email,
        notes: _notes,
        
      );

     
      await Provider.of<LeadProvider>(context, listen: false).updateLead(updatedLead);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lead updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Update Lead Information'),
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
                initialValue: _name,
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                label: 'Phone Number',
                initialValue: _phone,
                onSaved: (value) => _phone = value!,
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                label: 'Email Address',
                initialValue: _email,
                onSaved: (value) => _email = value!,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Email is required' : null,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                label: 'Notes / Description',
                initialValue: _notes,
                onSaved: (value) => _notes = value!,
                maxLines: 5,
                isOptional: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _updateLead,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Update Lead', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
    bool isOptional = false,
    String? initialValue,
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
          initialValue: initialValue,
          decoration: InputDecoration(
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