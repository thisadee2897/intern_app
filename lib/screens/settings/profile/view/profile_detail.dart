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
  bool _isSaveHovered = false;
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    final isLoading = ref.watch(profileControllerProvider).isLoading;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // พื้นหลังรูปภาพ
          Image.network(
            'https://images.pexels.com/photos/314726/pexels-photo-314726.jpeg',
            fit: BoxFit.cover,
          ),
          // overlay สีดำโปร่งแสง
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          // ฟอร์มโปรไฟล์
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(32),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar + edit effect
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade200, Colors.blue.shade600],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: imageController.text.isNotEmpty
                                  ? NetworkImage(imageController.text)
                                  : null,
                              child: imageController.text.isEmpty
                                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'แก้ไขข้อมูลส่วนตัว',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 10, 15, 20)),
                        ),
                        const SizedBox(height: 24),
                        // Name
                        TextField(
                          controller: nameController,
                          decoration: _inputDecoration('Name', Icons.person),
                        ),
                        const SizedBox(height: 20),
                        // Email
                        TextField(
                          controller: emailController,
                          decoration: _inputDecoration('Email', Icons.email),
                        ),
                        const SizedBox(height: 20),
                        // Phone
                        TextField(
                          controller: phoneController,
                          decoration: _inputDecoration('Phone', Icons.phone),
                        ),
                        const SizedBox(height: 20),
                        // รูป preview (ใหญ่)
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
                        // Image URL toggle
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: imageController,
                                enabled: isEditingImage,
                                decoration: _inputDecoration('Image URL', Icons.image),
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
                          child: MouseRegion(
                            onEnter: (_) => setState(() => _isSaveHovered = true),
                            onExit: (_) => setState(() => _isSaveHovered = false),
                            child: AnimatedScale(
                              scale: _isSaveHovered ? 1.06 : 1.0,
                              duration: const Duration(milliseconds: 160),
                              curve: Curves.easeOut,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.save),
                                label: isLoading ? const Text('Saving...') : const Text('Save'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(fontSize: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  elevation: 8,
                                  shadowColor: Colors.blueAccent,
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        if (nameController.text.trim().isEmpty ||
                                            emailController.text.trim().isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('กรุณากรอกชื่อและอีเมล'),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          );
                                          return;
                                        }
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
