
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';
import '../widgets/status_badge.dart';
import 'edit_lead_screen.dart';

class LeadDetailsScreen extends StatelessWidget {
  final Lead lead;
  const LeadDetailsScreen({super.key, required this.lead});

  Color _getStatusColor(LeadStatus status) {
    switch (status) {
      case LeadStatus.New: return Colors.blue.shade600;
      case LeadStatus.Contacted: return Colors.orange.shade700;
       case LeadStatus.Lost: return Colors.grey.shade600;
      case LeadStatus.Converted: return Colors.green.shade600;
     
    }
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 16, thickness: 0.5),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  
  void _updateStatus(BuildContext context, Lead lead, LeadStatus newStatus) {
    final provider = Provider.of<LeadProvider>(context, listen: false);
    final updatedLead = lead.copyWith(status: newStatus, updatedAt: DateTime.now());
    provider.updateLead(updatedLead);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${lead.name} status updated to ${newStatus.name}')),
    );
  }

 
  void _confirmDelete(BuildContext context, Lead lead) {
    final provider = Provider.of<LeadProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Lead'),
        content: Text('Are you sure you want to delete ${lead.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.deleteLead(lead.id!);
              if (ctx.mounted) {
                Navigator.of(ctx).pop(); 
                Navigator.of(context).pop(); // Go back to list screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${lead.name} deleted successfully!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
   
    return Consumer<LeadProvider>(
      builder: (context, provider, child) {
       
        final currentLead = provider.allLeads.firstWhere(
              (l) => l.id == lead.id,
              orElse: () => lead,
        );
        
        final formattedUpdateDate = DateFormat('MMM dd, yyyy at h:mm a').format(currentLead.updatedAt);

        return Scaffold(
          
          appBar: AppBar(
            title: const Text('Lead Details'),
         
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditLeadScreen(lead: currentLead)),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(currentLead.name, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                            StatusBadge(status: currentLead.status, isLarge: true),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('Last updated $formattedUpdateDate', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
              
                _buildInfoCard(
                  context,
                  title: 'Contact Information',
                  children: [
                    _buildContactRow(context, Icons.phone, 'Phone', currentLead.phone),
                    _buildContactRow(context, Icons.email, 'Email', currentLead.email),
                  ],
                ),
                const SizedBox(height: 16),
    
               
                _buildInfoCard(
                  context,
                  title: 'Update Lead Status',
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 15, 15, 15),
                      child: Wrap(
                        spacing: 100.0,
                        runSpacing: 10.0,
                        children: LeadStatus.values.map((status) {
                          final isSelected = currentLead.status == status;
                          return ActionChip(
                            label: Text(
                              status.name,
                              style: TextStyle(
                                color: isSelected ? Colors.white : _getStatusColor(status),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            backgroundColor: isSelected ? _getStatusColor(status) : Theme.of(context).cardColor,
                            side: BorderSide(color: _getStatusColor(status), width: 1),
                            onPressed: () {
                              if (!isSelected) {
                                _updateStatus(context, currentLead, status); 
                              }
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
    
               
                _buildInfoCard(
                  context,
                  title: 'Notes',
                  children: [
                    Text(currentLead.notes.isEmpty ? 'No notes added.' : currentLead.notes),
                  ],
                ),
                const SizedBox(height: 32),
    
               
                OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context, currentLead),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Lead', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}