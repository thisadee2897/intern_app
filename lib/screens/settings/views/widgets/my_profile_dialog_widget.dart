// ignore_for_file: use_build_context_synchronously  
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/auth/widgets/glass_container.dart';
import 'package:project/screens/settings/profile/provider/controller/my_profile_controller.dart';
import 'package:project/utils/extension/custom_snackbar.dart';
import 'package:project/utils/extension/hex_color.dart';

class MyProfileDialogWidget extends ConsumerStatefulWidget {
  const MyProfileDialogWidget({super.key});

  @override
  ConsumerState<MyProfileDialogWidget> createState() =>
      _MyProfileDialogWidgetState();
}

class _MyProfileDialogWidgetState
    extends ConsumerState<MyProfileDialogWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchProfile();
      ref.read(profileImageProvider.notifier).fetchProfileImage();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
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

        await ref
            .read(profileImageProvider.notifier)
            .updateProfileImage(tempFile);
        await tempFile.delete();

        if (context.mounted) {
          CustomSnackbar.showSnackBar(
            context: context,
            title: 'สำเร็จ',
            message: 'อัพโหลดรูปภาพสำเร็จ',
            contentType: ContentType.success,
            color: Colors.green,
          );
        }
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

  Widget _buildUploadSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () => _pickAndUploadImage(context),
            icon: const Icon(Icons.upload, color: Colors.white),
            label: const Text('อัพโหลด', style: TextStyle(color: Colors.white)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: HexColor.fromHex('#002B77'), width: 2),
              backgroundColor: HexColor.fromHex('#003B99'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'support file types: jpg, png',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final imageState = ref.watch(profileImageProvider);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,   // จำกัดความกว้างสูงสุด
              maxHeight: 800,  // จำกัดความสูงสูงสุด
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FloatingCard(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      // Header
                      Text(
                        'My Profile',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white70, thickness: 1),
                      const SizedBox(height: 16),

                      // Body
                      Expanded(
                        child: state.when(
                          data: (userData) => Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Profile Image
                              Flexible(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        HexColor.fromHex('#00C6FF'),
                                        HexColor.fromHex('#0072FF'),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: HexColor.fromHex('#001B4B'),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              child: imageState.when(
                                                data: (imageData) =>
                                                    imageData != null
                                                        ? CachedNetworkImage(
                                                            imageUrl: imageData,
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Center(
                                                                    child: CircularProgressIndicator(
                                                                        color: Colors
                                                                            .white)),
                                                            errorWidget: (context,
                                                                    url, error) =>
                                                                _buildUploadSection(),
                                                          )
                                                        : _buildUploadSection(),
                                                loading: () => const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Colors.white)),
                                                error: (_, __) =>
                                                    _buildUploadSection(),
                                              ),
                                            ),
                                            if (userData.image != null &&
                                                userData.image!.isNotEmpty)
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    final bool? confirmDelete =
                                                        await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        backgroundColor:
                                                            HexColor.fromHex(
                                                                '#002B77'),
                                                        title: const Text(
                                                            'ยืนยันการลบ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        content: const Text(
                                                          'คุณต้องการลบรูปโปรไฟล์หรือไม่?',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false),
                                                            child: const Text(
                                                                'ยกเลิก',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true),
                                                            child: const Text(
                                                                'ลบ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    if (confirmDelete ==
                                                        true) {
                                                      try {
                                                        await ref
                                                            .read(profileImageProvider
                                                                .notifier)
                                                            .deleteProfileImage(
                                                                userData
                                                                    .image!);
                                                      } catch (e) {
                                                        if (context.mounted) {
                                                          CustomSnackbar
                                                              .showSnackBar(
                                                            context: context,
                                                            title:
                                                                'เกิดข้อผิดพลาด',
                                                            message: '$e',
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                            color: Colors.red,
                                                          );
                                                        }
                                                      }
                                                    }
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.white),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Form Section
                              Flexible(
                                flex: 1,
                                child: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ..._buildFormFields(userData)
                                            .map((field) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16),
                                                  child: field,
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          loading: () => const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white)),
                          error: (error, stack) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 48, color: Colors.red),
                                const SizedBox(height: 16),
                                Text('เกิดข้อผิดพลาด: $error',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => ref
                                      .read(profileProvider.notifier)
                                      .fetchProfile(),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  child: const Text('ลองใหม่',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: HexColor.fromHex('#002B77'), width: 2),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 28),
                            ),
                            child: const Text('ปิด',
                                style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                try {
                                  await ref
                                      .read(profileProvider.notifier)
                                      .updateProfile();
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
                            style: FilledButton.styleFrom(
                              backgroundColor: HexColor.fromHex('#003B99'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 28),
                            ),
                            child: const Text('บันทึก',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(userData) {
    return [
      _buildTextField('ชื่อ', userData.name, MyProfileField.name,
          icon: Icons.person),
      _buildTextField('ชื่อเล่น', userData.publicName,
          MyProfileField.publicName,
          icon: Icons.person_outline),
      _buildTextField(
        'อีเมล',
        userData.email,
        MyProfileField.email,
        icon: Icons.email_outlined,
        validator: (value) {
          if (value == null || value.isEmpty) return 'กรุณากรอกอีเมล';
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'รูปแบบอีเมลไม่ถูกต้อง';
          }
          return null;
        },
      ),
      _buildTextField('เบอร์โทร', userData.phoneNumber,
          MyProfileField.phoneNumber,
          icon: Icons.phone),
      _buildTextField('ตำแหน่งงาน', userData.jobTitle,
          MyProfileField.jobTitle,
          icon: Icons.work),
      _buildTextField('แผนก', userData.department, MyProfileField.department,
          icon: Icons.apartment),
      _buildTextField('สถานที่ปฏิบัติงาน', userData.baseIn,
          MyProfileField.baseIn,
          icon: Icons.location_on),
    ];
  }

  Widget _buildTextField(
  String label,
  String? initialValue,
  MyProfileField field, {
  String? Function(String?)? validator,
  IconData? icon,
}) {
  return TextFormField(
    initialValue: initialValue,
    style: const TextStyle(color: Colors.white),
    validator: validator,
    onChanged: (value) =>
        ref.read(profileProvider.notifier).updateField(field, value),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: HexColor.fromHex('#001B4B'),
      hoverColor: HexColor.fromHex('#001B4B'),
      prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
      isDense: true, // ✅ ทำให้ฟิลด์ไม่สูงเกินไป
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16, // ✅ เพิ่ม padding ด้านบน/ล่าง ให้สระไทยไม่โดนตัด
        horizontal: 20,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: HexColor.fromHex('#00C6FF'), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 3),
      ),
    ),
  );
}

}
