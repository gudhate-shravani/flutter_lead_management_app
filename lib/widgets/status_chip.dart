
import 'package:flutter/material.dart';
import '../models/lead_model.dart';

class StatusChip extends StatelessWidget {
  final LeadStatus? status;
  final int count;
  final bool isSelected;
  final VoidCallback onSelected;

  const StatusChip({
    super.key,
    required this.status,
    required this.count,
    required this.isSelected,
    required this.onSelected,
  });

 
  Color _getColor(BuildContext context) {
    if (status == null) return Theme.of(context).colorScheme.primary;
    switch (status!) {
      case LeadStatus.New: return Colors.blue.shade600;
      case LeadStatus.Contacted: return Colors.orange.shade700;
      case LeadStatus.Converted: return Colors.green.shade600;
      case LeadStatus.Lost: return Colors.grey.shade600;
    }
  }
  
  String _getLabel() {
    if (status == null) return 'All';
    return status!.name[0].toUpperCase() + status!.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(context);
    
    return ActionChip(
      label: Text(
        '${_getLabel()} ($count)',
        style: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: isSelected ? color : Theme.of(context).cardColor,
      side: BorderSide(
        color: isSelected ? color : Colors.grey.shade300,
        width: 1,
      ),
      onPressed: onSelected,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}