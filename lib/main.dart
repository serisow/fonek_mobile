import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// [CORRECTION] We no longer import repositories or controllers here.
import 'src/presentation/screens/auth_widget.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // [MODIFICATION] Le ProviderScope est le widget qui rend les providers disponibles.
  runApp(const ProviderScope(child: MyApp())); 
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
      // [MODIFICATION] AuthWidget devient notre point d'entrée.
      home: const AuthWidget(), 
    );
  }
}