import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/data/repositories/auth_repository.dart';
import 'src/data/repositories/auth_repository_impl.dart';

void main() {
  runApp(
    // The "Grand Assembler" for our Liaison Agents.
    // We fabricate our agents and make them available
    // to the entire application via Provider.
    MultiProvider(
      providers: [
        // Ici, nous fabriquons et fournissons notre premier Agent de Liaison.
        Provider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(),
        ),
        // Later, we will add SessionRepository, UserRepository, etc. here.
      ],
      child: const MyApp(), // Our application is now a child of the Provider.
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fonek',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fonek MVP - Data Layer Test'),
        ),
        body: const Center(
          child: Text('Foundation is laid. Ready to build the UI.'),
        ),
      ),
    );
  }
}