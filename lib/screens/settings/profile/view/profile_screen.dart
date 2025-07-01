import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/settings/profile/provider/controller/profile_controller.dart';
import 'package:project/screens/settings/profile/view/profile_detail.dart'; // เพิ่ม import

class ProfileScreen extends BaseStatefulWidget {
  const ProfileScreen({super.key});

  @override
  BaseState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      ref.read(profileControllerProvider.notifier).fetchProfile());
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: Consumer(
        builder: (context, ref, _) {
          final profileAsync = ref.watch(profileControllerProvider);
          return profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
            data: (user) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 64),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: user.image != null && user.image!.isNotEmpty
                          ? NetworkImage(user.image!)
                          : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
                        child: user.image == null || user.image!.isEmpty
                          ? const Icon(Icons.person, size: 70, color: Colors.grey)
                          : null,
                      ),
                    ],
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ข้อมูลส่วนตัว', style: Theme.of(context).textTheme.titleLarge),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(user: user),
                                  ),
                                ).then((updated) {
                                  if (updated == true) {
                                    ref.read(profileControllerProvider.notifier).fetchProfile(); // โหลดใหม่หลังแก้
                                  }
                                });
                              },
                              child: const Text('(click for edit)', style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (user.name != null && user.name!.isNotEmpty) _profileInfoRow('Name', user.name),
                        if (user.publicName != null && user.publicName!.isNotEmpty) _profileInfoRow('ชื่อภาษาไทย', user.publicName),
                        if (user.email != null && user.email!.isNotEmpty) _profileInfoRow('Email', user.email),
                        if (user.jobTitle != null && user.jobTitle!.isNotEmpty) _profileInfoRow('Level', user.jobTitle),
                        if (user.department != null && user.department!.isNotEmpty) _profileInfoRow('Department', user.department),
                        if (user.baseIn != null && user.baseIn!.isNotEmpty) _profileInfoRow('Base In', user.baseIn),
                        if (user.id != null && user.id!.isNotEmpty) _profileInfoRow('ID', user.id),
                        if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) _profileInfoRow('Phone', user.phoneNumber),
                        if (user.createdAt != null && user.createdAt!.isNotEmpty) _profileInfoRow('Created At', user.createdAt),
                        if (user.updatedAt != null && user.updatedAt!.isNotEmpty) _profileInfoRow('Updated At', user.updatedAt),
                        if (user.active != null) _profileInfoRow('Active', user.active.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _profileInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 160, child: Text('$label :', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value ?? '-', style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) =>
      Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) =>
      Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
}
