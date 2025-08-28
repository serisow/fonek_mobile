import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers.dart';

// HomeScreen is a UI Liaison Agent. It translates user actions
// into commands for the SessionController (our Decider).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _phoneController = TextEditingController();
  int _selectedDurationMinutes = 15; // Default duration

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // UI Artisan that gives the command to the Decider.
  void _createSession() {
    final recipientPhone = _phoneController.text.trim();
    if (recipientPhone.isEmpty) {
      // TODO: Show a snackbar error
      return;
    }

    // Command the SessionController to create the session.
    // The UI doesn't know how this is done; it just gives the order.
    ref.read(sessionControllerProvider.notifier).createSession(
          recipientPhone: '+$recipientPhone', // Assuming a country code prefix is needed
          durationInMinutes: _selectedDurationMinutes,
        );
  }

  @override
  Widget build(BuildContext context) {
    // We will listen to the sessionController to handle navigation or errors later.
    // final sessionState = ref.watch(sessionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fonek - New Session'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Who do you want to share your location with?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Recipient\'s Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildDurationSelector(),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: _createSession,
              child: const Text('Send Share Request'),
            ),
          ],
        ),
      ),
    );
  }

  // A helper widget for the duration buttons.
  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Share for:", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [15, 30, 60].map((minutes) {
            return ChoiceChip(
              label: Text('$minutes min'),
              selected: _selectedDurationMinutes == minutes,
              onSelected: (isSelected) {
                if (isSelected) {
                  setState(() {
                    _selectedDurationMinutes = minutes;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}