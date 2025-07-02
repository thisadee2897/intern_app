import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/components/export.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/config/routes/route_helper.dart';
import '../../auth/providers/controllers/auth_controller.dart';


class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(logoutProvider.future);
              ref.goFromPath(Routes.login);
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          ListTile(
            title: const Text('My Profile'),
            subtitle: const Text('View and edit your profile'),
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.push('/setting/profile');
            },
          ),
        ],
      ),
    );
  }
}
