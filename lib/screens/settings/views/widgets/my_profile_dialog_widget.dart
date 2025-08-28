// // ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/settings/profile/provider/controller/my_profile_controller.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';
import 'package:project/utils/extension/custom_snackbar.dart';

class MyProfileDialogWidget extends ConsumerStatefulWidget {
  const MyProfileDialogWidget({super.key});

  @override
  ConsumerState<MyProfileDialogWidget> createState() => _MyProfileDialogWidgetState();
}

class _MyProfileDialogWidgetState extends ConsumerState<MyProfileDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchProfile();
      ref.read(profileImageProvider.notifier).fetchProfileImage();
    });
      super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(profileProvider);
        final imageState = ref.watch(profileImageProvider);

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text('My Profile'),
          content: SizedBox(
            width: 1030,
            height: 650,
            child: SingleChildScrollView(
              child: state.when(
                data: (userData) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Section
                    Flexible(
                      flex: 1,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: Colors.grey,
                          dashPattern: const [6, 3],
                          radius: Radius.circular(20),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: imageState.appWhen(
                                  dataBuilder: (imageData) => CachedNetworkImage(
                                    imageUrl: imageData ?? '',
                                    fit: BoxFit.cover, // ทำให้รูปเต็มพื้นที่
                                    width: double.infinity, // ขยายเต็มแนวนอน
                                    height: double.infinity,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton.icon(
                                            onPressed: () async {
                                              try {
                                                final result = await FilePicker.platform.pickFiles(
                                                  type: FileType.custom,
                                                  allowMultiple: false,
                                                  allowedExtensions: const ['jpg', 'jpeg', 'png'],
                                                  withData: true,
                                                );

                                                if (result != null && result.files.single.bytes != null) {
                                                  final platformFile = result.files.single;
                                                  final bytes = platformFile.bytes!;
                                                  final tempDir = Directory.systemTemp;
                                                  String fileName = platformFile.name;
                                                  if (!fileName.toLowerCase().endsWith('.jpg') &&
                                                      !fileName.toLowerCase().endsWith('.jpeg') &&
                                                      !fileName.toLowerCase().endsWith('.png')) {
                                                    fileName = '$fileName.jpg';
                                                  }
                                                  final tempFile = File('${tempDir.path}/$fileName');
                                                  await tempFile.writeAsBytes(bytes);

                                                  await ref.read(profileImageProvider.notifier).updateProfileImage(tempFile);
                                                  await tempFile.delete();

                                                  if (context.mounted) {
                                                    print('Profile image updated successfully');
                                                    ScaffoldMessenger.of(context).clearSnackBars();
                                                    CustomSnackbar.showSnackBar(
                                                      context: context,
                                                      title: 'สำเร็จ',
                                                      message: 'อัพโหลดรูปภาพสำเร็จ',
                                                      contentType: ContentType.success,
                                                      color: Colors.green,
                                                    );
                                                  }
                                                }
                                              } catch (e, stx) {
                                                print('Error: $e');
                                                print('StackTrace: $stx');
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).clearSnackBars();
                                                  CustomSnackbar.showSnackBar(
                                                    context: context,
                                                    title: 'เกิดข้อผิดพลาด',
                                                    message: '$e',
                                                    contentType: ContentType.failure,
                                                    color: Colors.red,
                                                  );
                                                }
                                              }
                                            },
                                            icon: const Icon(Icons.upload),
                                            label: const Text('อัพโหลด'),
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text('support file types: jpg, png'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (userData.image != null && userData.image!.isNotEmpty)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton.filled(
                                    onPressed: () async {
                                      final bool? confirmDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text('ยืนยันการลบ'),
                                          content: const Text('คุณต้องการลบรูปโปรไฟล์หรือไม่?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('ยกเลิก')),
                                            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('ลบ', style: TextStyle(color: Colors.red))),
                                          ],
                                        ),
                                      );
                                      if (confirmDelete == true) {
                                        try {
                                          await ref.read(profileImageProvider.notifier).deleteProfileImage(userData.image!);
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
                                          }
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.delete, color: Colors.black45),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Form Section
                    Flexible(
                      flex: 1,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._buildFormFields(userData),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('เกิดข้อผิดพลาด: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: () => ref.read(profileProvider.notifier).fetchProfile(), child: const Text('ลองใหม่')),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ปิด'),
            ),
            FilledButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    await ref.read(profileProvider.notifier).updateProfile();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      CustomSnackbar.showSnackBar(
                        context: context,
                        title: 'สำเร็จ',
                        message: 'บันทึกโปรไฟล์เรียบร้อยแล้ว',
                        contentType: ContentType.success,
                        color: Colors.green,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      CustomSnackbar.showSnackBar(
                        context: context,
                        title: 'เกิดข้อผิดพลาด',
                        message: '$e',
                        contentType: ContentType.failure,
                        color: Colors.red,
                      );
                    }
                  }
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildFormFields(userData) {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'ชื่อ'),
        initialValue: userData.name,
        onChanged: (value) => ref.read(profileProvider.notifier).updateField(MyProfileField.name, value),
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'ชื่อเล่น'),
        initialValue: userData.publicName,
        onChanged: (value) => ref.read(profileProvider.notifier).updateField(MyProfileField.publicName, value),
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'อีเมล'),
        initialValue: userData.email,
        validator: (value) {
          if (value == null || value.isEmpty) return 'กรุณากรอกอีเมล';
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'รูปแบบอีเมลไม่ถูกต้อง';
          return null;
        },
        onChanged: (value) => ref.read(profileProvider.notifier).updateField(MyProfileField.email, value),
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'เบอร์โทร'),
        initialValue: userData.phoneNumber,
        onChanged: (value) => ref.read(profileProvider.notifier).updateField(MyProfileField.phoneNumber, value),
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'ตำแหน่งงาน'),
        initialValue: userData.jobTitle,
        onChanged: (value) => ref.read(profileProvider.notifier).updateField(MyProfileField.jobTitle, value),
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'แผนก'),
        initialValue: userData.department,
        onChanged: (value) => ref.read(profileProvider.notifier).updateField(MyProfileField.department, value),
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'สถานที่ปฏิบัติงาน'),
        initialValue: userData.baseIn,
        onChanged: (value) => ref.read(profileProvider.notifier).updateField(MyProfileField.baseIn, value),
      ),
    ];
  }
}

