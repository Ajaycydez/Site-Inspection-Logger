import 'package:flutter/material.dart';
import 'package:sitelogger/features/auth/screens/LoginPage.dart';


void main() {
  runApp(const SiteInspectionApp());
}

class SiteInspectionApp extends StatelessWidget {
  const SiteInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Site Inspection Logger',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}









