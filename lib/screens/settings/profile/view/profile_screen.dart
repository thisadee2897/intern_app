import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/settings/profile/provider/controller/profile_controller.dart';
import 'package:project/screens/settings/profile/view/profile_detail.dart';

class ProfileScreen extends BaseStatefulWidget {
  const ProfileScreen({super.key});

  @override
  BaseState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseState<ProfileScreen> {
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileControllerProvider.notifier).fetchProfile());
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Consumer(
        builder: (context, ref, _) {
          final profileAsync = ref.watch(profileControllerProvider);
          return profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
            data: (user) => Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                constraints: const BoxConstraints(maxWidth: 900),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: user.image != null && user.image!.isNotEmpty
                                ? NetworkImage(user.image!)
                                : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
                            child: user.image == null || user.image!.isEmpty
                                ? const Icon(Icons.person, size: 70, color: Colors.grey)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 48),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ข้อมูลส่วนตัว',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (context) => EditProfileScreen(user: user),
                                            ),
                                          )
                                          .then((updated) {
                                        if (updated == true) {
                                          ref.read(profileControllerProvider.notifier).fetchProfile();
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                                    label: const Text('(click for edit)', style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Wrap(
                                runSpacing: 12,
                                children: [
                                  if (user.name?.isNotEmpty ?? false) _profileInfoRow('Name', user.name),
                                  if (user.publicName?.isNotEmpty ?? false) _profileInfoRow('ชื่อภาษาไทย', user.publicName),
                                  if (user.email?.isNotEmpty ?? false) _profileInfoRow('Email', user.email),
                                  if (user.jobTitle?.isNotEmpty ?? false) _profileInfoRow('Level', user.jobTitle),
                                  if (user.department?.isNotEmpty ?? false) _profileInfoRow('Department', user.department),
                                  if (user.baseIn?.isNotEmpty ?? false) _profileInfoRow('Base In', user.baseIn),
                                  if (user.id?.isNotEmpty ?? false) _profileInfoRow('ID', user.id),
                                  if (user.phoneNumber?.isNotEmpty ?? false) _profileInfoRow('Phone', user.phoneNumber),
                                  if (user.createdAt?.isNotEmpty ?? false) _profileInfoRow('Created At', user.createdAt),
                                  if (user.updatedAt?.isNotEmpty ?? false) _profileInfoRow('Updated At', user.updatedAt),
                                  if (user.active != null) _profileInfoRow('Active', user.active.toString()),
                                  if (user.password?.isNotEmpty ?? false)
                                    _profileInfoRow(
                                      'Password',
                                      _obscurePassword ? '••••••••' : user.password,
                                      icon: IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _profileInfoRow(String label, String? value, {Widget? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Text('$label :', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: Text(value ?? '-', style: const TextStyle(color: Colors.black87))),
              if (icon != null) icon,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) =>
      Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) =>
      Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
}
