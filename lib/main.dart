import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/presentation/screens/auth_widget.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // The ProviderScope is the widget which make providers available.
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
      // AuthWidget: the entrypoint
      home: const AuthWidget(), 
    );
  }
}