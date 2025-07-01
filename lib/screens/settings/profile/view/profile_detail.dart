import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/settings/profile/provider/controller/profile_controller.dart';

class EditProfileScreen extends BaseStatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  BaseState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends BaseState<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController imageController;

  bool isEditingImage = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    imageController = TextEditingController(text: widget.user.image);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    imageController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    final isLoading = ref.watch(profileControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                TextField(
                  controller: nameController,
                  decoration: _inputDecoration('Name'),
                ),
                const SizedBox(height: 20),

                // Email
                TextField(
                  controller: emailController,
                  decoration: _inputDecoration('Email'),
                ),
                const SizedBox(height: 20),

                // Phone
                TextField(
                  controller: phoneController,
                  decoration: _inputDecoration('Phone'),
                ),
                const SizedBox(height: 20),

                // Image preview
                if (imageController.text.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      imageController.text,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(child: Text('Invalid image URL')),
                      ),
                    ),
                  ),

                // Image URL with toggle
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: imageController,
                        decoration: _inputDecoration('Image URL'),
                        enabled: isEditingImage,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Clear image',
                      onPressed: () {
                        imageController.clear();
                        setState(() {});
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEditingImage = !isEditingImage;
                          if (!isEditingImage) {
                            imageController.text = widget.user.image ?? '';
                          }
                        });
                      },
                      child: Text(isEditingImage ? 'ยกเลิก' : 'แก้ไข'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: isLoading ? const Text('Saving...') : const Text('Save'),
                    onPressed: isLoading
                        ? null
                        : () async {
                            final updatedUser = widget.user.copyWith(
                              name: nameController.text,
                              email: emailController.text,
                              phoneNumber: phoneController.text,
                              image: imageController.text,
                            );

                            await ref
                                .read(profileControllerProvider.notifier)
                                .updateProfile(updatedUser);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated successfully')),
                            );

                            Navigator.pop(context, true);
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
  }
}
