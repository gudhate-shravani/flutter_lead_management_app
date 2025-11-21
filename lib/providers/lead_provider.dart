
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart'; 
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/lead_model.dart';
import '../services/database_service.dart';

class LeadProvider extends ChangeNotifier {
  final DatabaseService _dbService;
  
  List<Lead> _allLeads = [];
  LeadStatus? _currentFilter; 
  String _currentSearchTerm = '';
  ThemeMode _themeMode = ThemeMode.light;

  // Getters for UI access
  List<Lead> get allLeads => _allLeads;
  LeadStatus? get currentFilter => _currentFilter;
  String get currentSearchTerm => _currentSearchTerm;
  ThemeMode get themeMode => _themeMode;

  LeadProvider(this._dbService) {
    fetchLeads(); 
  }
  
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  
 

  List<Lead> get filteredLeads {
    List<Lead> leads = _allLeads;
    
    
    if (_currentSearchTerm.isNotEmpty) {
      leads = leads.where((lead) => 
        lead.name.toLowerCase().contains(_currentSearchTerm)
      ).toList();
    }
    
   
    if (_currentFilter != null) {
      leads = leads.where((lead) => lead.status == _currentFilter).toList();
    }
    
    return leads;
  }
  
  int getLeadCountByStatus(LeadStatus? status) {
    if (status == null) return _allLeads.length;
    return _allLeads.where((lead) => lead.status == status).length;
  }
  
  
  void setFilter(LeadStatus? status) {
    _currentFilter = status;
    notifyListeners();
  }

  void setSearchTerm(String term) {
    _currentSearchTerm = term.toLowerCase();
    notifyListeners();
  }

  

  Future<void> fetchLeads() async {
    _allLeads = await _dbService.readAllLeads();
    notifyListeners();
  }

  Future<void> addLead(Lead lead) async {
    final newLead = await _dbService.create(lead);
    _allLeads.insert(0, newLead); 
    notifyListeners();
  }

  Future<void> updateLead(Lead updatedLead) async {
    await _dbService.update(updatedLead);
    
    final index = _allLeads.indexWhere((lead) => lead.id == updatedLead.id);
    if (index != -1) {
        _allLeads[index] = updatedLead;
    }
   
    _allLeads.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  Future<void> deleteLead(int id) async {
    await _dbService.delete(id);
    _allLeads.removeWhere((lead) => lead.id == id);
    notifyListeners();
  }
  
  
  Future<bool> exportLeadsToJson() async {
    try {
      
      final leadMaps = _allLeads.map((e) => e.toJson()).toList(); 
      final jsonString = jsonEncode(leadMaps);
      
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/leads_export_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);
      
     
      await Share.shareXFiles([XFile(file.path, mimeType: 'application/json')]);
      return true;
    } catch (e) {
      print('Error exporting leads: $e');
      return false;
    }
  }

  Future<String?> generateLeadsJsonString() async {
    try {
     
      final List<Map<String, dynamic>> leadsJsonList = 
          allLeads.map((lead) => lead.toJson()).toList();

    
      final Map<String, dynamic> fullData = {'leads': leadsJsonList};

    
      final String jsonString = const JsonEncoder.withIndent('  ').convert(fullData);
      
      return jsonString;
    } catch (e) {
      
      debugPrint('Error generating JSON string: $e');
      return null;
    }
  }
}