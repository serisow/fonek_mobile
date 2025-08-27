import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/data/repositories/auth_repository.dart';
import 'src/data/repositories/auth_repository_impl.dart';
import 'src/presentation/screens/phone_auth_screen.dart'; // Import our new screen

// main() must be async to wait for dotenv to load.
Future<void> main() async {
  // Load environment variables before running the app.
  await dotenv.load(fileName: ".env");

  runApp(
    // The "Grand Assembler" must use MultiProvider
    // to be able to provide all our future dependencies.
    MultiProvider(
      providers: [
        // Here, we fabricate and provide our first Liaison Agent.
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // The home screen is now our authentication screen.
      home: const PhoneAuthScreen(),
    );
  }
}