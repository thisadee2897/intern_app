import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/settings/views/widgets/my_profile_dialog_widget.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          ListTile(
            title: const Text('My Profile'),
            subtitle: const Text('View and edit your profile'),
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              showDialog(
                
                context: context,
                builder: (context) {
                  return MyProfileDialogWidget();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
