import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart';  // ← Agrega esta línea
import 'home_screen.dart';   // ← Agrega esta línea

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SharedRoute',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // 👈 Inicia aquí
      // Rutas nombradas para navegar fácilmente
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}