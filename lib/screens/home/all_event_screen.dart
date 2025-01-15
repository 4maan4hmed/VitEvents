import 'package:flutter/material.dart';
import '../../models/event.dart'; // Import the Event model

class AllEventScreen extends StatelessWidget {
  const AllEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All events"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Text("All event screen cards will be here"),
    );
  }
}
