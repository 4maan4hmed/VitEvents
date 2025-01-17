import 'package:flutter/material.dart';

class AllEventScreen extends StatelessWidget {
  const AllEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All events"),
      ),
      body: const Text("All event screen cards will be here"),
    );
  }
}
