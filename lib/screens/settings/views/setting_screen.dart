import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out')),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ListView.builder(
        itemCount: 2000000,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Setting Item ${index + 1}'),
            subtitle: const Text('Description of the setting item'),
            leading: const Icon(Icons.settings),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle tap on setting item
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on Setting Item ${index + 1}')),
              );
            },
          );
        },
      ),
      );
  }
}
