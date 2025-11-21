
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/lead_provider.dart';
import 'services/database_service.dart';
import 'screens/lead_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(
    ChangeNotifierProvider( 
      create: (_) => LeadProvider(DatabaseService.instance),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    final themeMode = Provider.of<LeadProvider>(context).themeMode;

    return MaterialApp(
      title: 'Mini Lead Manager',
      debugShowCheckedModeBanner: false,
      
      
      theme: ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: const Color(0xFF4285F4),
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        cardColor: Colors.white,
        colorScheme: ColorScheme.light(primary: const Color(0xFF4285F4)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF4285F4),
          foregroundColor: Colors.white,
        )
      ),
      
      
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        primaryColor: const Color(0xFF4285F4),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        cardColor: const Color(0xFF2C2C2C),
        colorScheme: ColorScheme.dark(primary: const Color(0xFF4285F4)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF4285F4),
          foregroundColor: Colors.white,
        )
      ),
      
      themeMode: themeMode,
      home: const LeadListScreen(),
    );
  }
}