


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';
import '../widgets/lead_card.dart';
import '../widgets/status_chip.dart';
import 'add_lead_screen.dart';
import 'lead_details_screen.dart';

class LeadListScreen extends StatelessWidget {
  const LeadListScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    final provider = Provider.of<LeadProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Mini Lead Manager', style: TextStyle(fontWeight: FontWeight.bold)),
        
        surfaceTintColor: Colors.transparent, 
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(bottom: 8.0),
            child: Consumer<LeadProvider>( // Consumer for search input
              builder: (context, p, child) => TextField(
                decoration: InputDecoration(
                  hintText: 'Search leads by name...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                    borderSide: BorderSide(color: const Color.fromARGB(255, 240, 238, 238))
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
                onChanged: p.setSearchTerm,
              ),
            ),
          ),
        ),
        actions: [
         
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => _showExportDialog(context, provider),
          ),
          
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
            onPressed: provider.toggleTheme,
          ),
        ],
      ),
      body: Consumer<LeadProvider>( 
        builder: (context, p, child) {
          final leads = p.filteredLeads;
          final totalLeadCount = p.allLeads.length;
          final currentFilter = p.currentFilter;
          final searchTerm = p.currentSearchTerm;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text(
                  '$totalLeadCount lead${totalLeadCount == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              _buildFilterChips(context, p, currentFilter),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                  itemCount: leads.length + 1, 
                  itemBuilder: (context, index) {
                    if (index < leads.length) {
                      final lead = leads[index];
                    
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => LeadDetailsScreen(lead: lead)),
                            );
                            
                            p.fetchLeads(); 
                          },
                          child: LeadCard(lead: lead),
                        ),
                      );
                    } else {
                     
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: totalLeadCount == 0 && searchTerm.isEmpty && currentFilter == null
                              ? const Text('No leads found.')
                              : const Text("You've reached the end of the list"),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddLeadScreen()),
          );
          provider.fetchLeads(); 
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, LeadProvider provider, LeadStatus? currentFilter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
        
          StatusChip(
            status: null,
            count: provider.getLeadCountByStatus(null),
            isSelected: currentFilter == null,
            onSelected: () => provider.setFilter(null),
          ),
          const SizedBox(width: 8),
         
          ...LeadStatus.values.map((status) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: StatusChip(
              status: status,
              count: provider.getLeadCountByStatus(status),
              isSelected: currentFilter == status,
              onSelected: () => provider.setFilter(status),
            ),
          )),
        ],
      ),
    );
  }







void _showJsonViewDialog(BuildContext parentContext, String jsonContent, LeadProvider provider) {
 showDialog(
 context: parentContext, 
 builder: (dialogContext) { 
 return AlertDialog(
 title: const Center(child: Text('Leads JSON Data')),
 content: SizedBox(
 width: MediaQuery.of(dialogContext).size.width * 0.8, 
 height: MediaQuery.of(dialogContext).size.height * 0.6, 
 child: SingleChildScrollView(
 child: SelectableText( 
 jsonContent,
 style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
 ),
 ),
 ),
 actions: [
 TextButton(
 onPressed: () => Navigator.of(dialogContext).pop(),
 child: const Text('Close'),
 ),
 ElevatedButton.icon(
 icon: const Icon(Icons.download),
 label: const Text('Export as File'),
 onPressed: () async {
 Navigator.of(dialogContext).pop(); 

  ScaffoldMessenger.of(parentContext).showSnackBar(
 const SnackBar(content: Text('Saving JSON file...')),
 );
    await provider.exportLeadsToJson(); 
 ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();


 },
 ),
 ],
 );
 },
 );
}





void _showExportDialog(BuildContext parentContext, LeadProvider provider) {
final totalCount = provider.allLeads.length;
 showDialog(
 context: parentContext, 
builder: (dialogContext) { 
return AlertDialog(
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
 title: const Center(child: Icon(Icons.code, size: 40)),
   content: Column(
   mainAxisSize: MainAxisSize.min,
           children: [
   Text(
   'Export Leads',
   style: Theme.of(dialogContext).textTheme.titleLarge,
   ),
   const SizedBox(height: 10),
 Text(
   'Export all $totalCount leads as a JSON file. This file can be imported later or used for backup purposes. You can also view the raw JSON data.',
   textAlign: TextAlign.center,
),
   ],
   ),
   actionsAlignment: MainAxisAlignment.spaceEvenly,
   actions: [
  TextButton(
   onPressed: () => Navigator.of(dialogContext).pop(),
child: const Text('Cancel'),
 ),


Row( children: 
[ ElevatedButton.icon(
 icon: const Icon(Icons.remove_red_eye),
 label: const Text('View JSON'),
 onPressed: () async {
 Navigator.of(dialogContext).pop();

ScaffoldMessenger.of(parentContext).showSnackBar(
 const SnackBar(content: Text('Preparing data...')),
 );

 final jsonString = await provider.generateLeadsJsonString(); 
ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();
 if (jsonString != null) {
 
 _showJsonViewDialog(parentContext, jsonString, provider); 
} else {
ScaffoldMessenger.of(parentContext).showSnackBar(
 const SnackBar(
 content: Text('Failed to generate JSON data.'),
 backgroundColor: Colors.red,
 ),
 );
 }
 },
 ),
 SizedBox(width: 8),
 ElevatedButton.icon(
 icon: const Icon(Icons.download),
 label: const Text('Export'), 
 onPressed: () async {
Navigator.of(dialogContext).pop();

 ScaffoldMessenger.of(parentContext).showSnackBar(
 const SnackBar(content: Text('Preparing data... Generating JSON file...')),
  );

await provider.exportLeadsToJson();
 ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();


 
 },
 ),])
 ],
 );
},
);
}



}
