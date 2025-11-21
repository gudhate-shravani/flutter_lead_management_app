

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/lead_model.dart';
import 'status_badge.dart';

class LeadCard extends StatelessWidget {
   final Lead lead;
 const LeadCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
   return Card(
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
                Expanded(
                  child: Text(
 lead.name,
 style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
 overflow: TextOverflow.ellipsis,
 ),
           ),
            StatusBadge(status: lead.status), // Status Badge
          const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
             ],
 ),
         const SizedBox(height: 4),
  Text(
               'Updated ${DateFormat('MMM dd').format(lead.updatedAt)}',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
         ),
          const SizedBox(height: 8),
             
   
   Row(
         crossAxisAlignment: CrossAxisAlignment.start,
 children: [
            const Icon(Icons.phone, size: 16, color: Colors.grey),
 const SizedBox(width: 8),
 Text(lead.phone, style: Theme.of(context).textTheme.bodyMedium),
 ],
 ),
        const SizedBox(height: 4),
 Row(
 crossAxisAlignment: CrossAxisAlignment.start,
  children: [
const Icon(Icons.email, size: 16, color: Colors.grey),
 const SizedBox(width: 8),
 Expanded(child: Text(lead.email, style: Theme.of(context).textTheme.bodyMedium)),
 ],
 ),
  
  
 if (lead.notes.isNotEmpty) ...[
          const SizedBox(height: 8),
           Text(
            lead.notes,
     maxLines: 2,
 overflow: TextOverflow.ellipsis,
 style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
 ),
 ]
],
 ),
),
 );
 }
}