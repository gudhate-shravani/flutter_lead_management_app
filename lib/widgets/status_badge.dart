
import 'package:flutter/material.dart';
import '../models/lead_model.dart';

class StatusBadge extends StatelessWidget {
  final LeadStatus status;
  final bool isLarge;
  
  const StatusBadge({super.key, required this.status, this.isLarge = false});

  Color _getColor() {
    switch (status) {
      case LeadStatus.New: return const Color(0xFF4285F4); // Blue
      case LeadStatus.Contacted: return Colors.orange.shade700;
       case LeadStatus.Lost: return Colors.grey.shade600;
      case LeadStatus.Converted: return Colors.green.shade600;
     
    }
  }
  
  String _getLabel() {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isLarge ? 12 : 8, vertical: isLarge ? 6 : 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: isLarge ? 1.5 : 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == LeadStatus.New ? Icons.flash_on : Icons.circle,
            color: color,
            size: isLarge ? 16 : 10,
          ),
          SizedBox(width: isLarge ? 6 : 4),
          Text(
            _getLabel(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: isLarge ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }
}