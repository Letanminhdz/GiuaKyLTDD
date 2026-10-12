import 'package:flutter/material.dart';
import 'screens/catalog_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EduTestApp());
}

class EduTestApp extends StatelessWidget {
  const EduTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduTest — Luyện thi TOEIC',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CatalogScreen(),
    );
  }
}
