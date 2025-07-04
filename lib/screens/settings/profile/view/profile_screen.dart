import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
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
  bool _isAvatarHovered = false;
  bool _isEditBtnHovered = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileControllerProvider.notifier).fetchProfile());
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
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

          // overlay สีดำโปร่งแสง เพื่อเพิ่มความสดของรูป
          Container(
            color: Colors.black.withOpacity(0.15),
          ),

          // เพิ่ม SingleChildScrollView เพื่อให้เลื่อนดูได้ พร้อมเว้นระยะห่างจาก appbar
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: kToolbarHeight + 24, bottom: 24),
            child: Consumer(
              builder: (context, ref, _) {
                final profileAsync = ref.watch(profileControllerProvider);
                return profileAsync.when(
                  loading: () => const Center(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 6,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    ),
                  ),
                  error: (e, st) => Center(child: Text('Error: $e')),
                  data: (user) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Card(
                          elevation: 16,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // รูปโปรไฟล์ + เอฟเฟกต์
                                MouseRegion(
                                  onEnter: (_) => setState(() => _isAvatarHovered = true),
                                  onExit: (_) => setState(() => _isAvatarHovered = false),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    transform: _isAvatarHovered
                                        ? (Matrix4.identity()..scale(1.08))
                                        : Matrix4.identity(),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Colors.blue.shade200, Colors.blue.shade600],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(255, 89, 149, 251).withOpacity(_isAvatarHovered ? 0.7 : 0.3),
                                          blurRadius: _isAvatarHovered ? 32 : 16,
                                          spreadRadius: _isAvatarHovered ? 8 : 2,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: _isAvatarHovered ? Colors.white : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.white,
                                      backgroundImage: user.image != null && user.image!.isNotEmpty
                                          ? NetworkImage(user.image!)
                                          : null,
                                      child: (user.image == null || user.image!.isEmpty)
                                          ? const Icon(Icons.person, size: 70, color: Colors.grey)
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 48),

                                // ข้อมูลโปรไฟล์
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // หัวข้อ + ปุ่มแก้ไข
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'ข้อมูลส่วนตัว',
                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          MouseRegion(
                                            onEnter: (_) => setState(() => _isEditBtnHovered = true),
                                            onExit: (_) => setState(() => _isEditBtnHovered = false),
                                            child: AnimatedScale(
                                              scale: _isEditBtnHovered ? 1.08 : 1.0,
                                              duration: const Duration(milliseconds: 180),
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) => EditProfileScreen(user: user),
                                                      ))
                                                      .then((updated) {
                                                    if (updated == true) {
                                                      ref.read(profileControllerProvider.notifier).fetchProfile();
                                                    }
                                                  });
                                                },
                                                icon: const Icon(Icons.edit, size: 16),
                                                label: const Text('แก้ไขข้อมูล'),
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  shape: const StadiumBorder(),
                                                  backgroundColor: _isEditBtnHovered ? Colors.blue.shade700 : Colors.blueAccent,
                                                  foregroundColor: Colors.white,
                                                  elevation: _isEditBtnHovered ? 8 : 2,
                                                  shadowColor: Colors.blueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      const Divider(thickness: 1, color: Colors.black12),
                                      const SizedBox(height: 16),

                                      // ข้อมูลรายละเอียด
                                      Wrap(
                                        runSpacing: 12,
                                        children: [
                                          if (user.name?.isNotEmpty ?? false)
                                            _profileInfoRow('Name', user.name, leadingIcon: Icons.person),
                                          if (user.publicName?.isNotEmpty ?? false)
                                            _profileInfoRow('ชื่อภาษาไทย', user.publicName, leadingIcon: Icons.translate),
                                          if (user.email?.isNotEmpty ?? false)
                                            _profileInfoRow('Email', user.email, leadingIcon: Icons.email),
                                          if (user.jobTitle?.isNotEmpty ?? false)
                                            _profileInfoRow('Level', user.jobTitle, leadingIcon: Icons.leaderboard),
                                          if (user.department?.isNotEmpty ?? false)
                                            _profileInfoRow('Department', user.department, leadingIcon: Icons.apartment),
                                          if (user.baseIn?.isNotEmpty ?? false)
                                            _profileInfoRow('Base In', user.baseIn, leadingIcon: Icons.place),
                                          if (user.id?.isNotEmpty ?? false)
                                            _profileInfoRow('ID', user.id, leadingIcon: Icons.perm_identity),
                                          if (user.phoneNumber?.isNotEmpty ?? false)
                                            _profileInfoRow('Phone', user.phoneNumber, leadingIcon: Icons.phone),
                                          if (user.createdAt?.isNotEmpty ?? false)
                                            _profileInfoRow('Created At', formatDate(user.createdAt),
                                                leadingIcon: Icons.calendar_today),
                                          if (user.updatedAt?.isNotEmpty ?? false)
                                            _profileInfoRow('Updated At', formatDate(user.updatedAt),
                                                leadingIcon: Icons.update),
                                          if (user.active != null)
                                            _profileInfoRow(
                                              'Active',
                                              null,
                                              valueWidget: _activeBadge(user.active!),
                                              leadingIcon: Icons.check_circle,
                                            ),
                                          if (user.password?.isNotEmpty ?? false)
                                            _profileInfoRow(
                                              'Password',
                                              _obscurePassword ? '••••••••' : user.password,
                                              icon: IconButton(
                                                icon: Icon(
                                                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _obscurePassword = !_obscurePassword;
                                                  });
                                                },
                                              ),
                                              leadingIcon: Icons.lock,
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileInfoRow(
    String label,
    String? value, {
    Widget? icon,
    IconData? leadingIcon,
    Widget? valueWidget,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leadingIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 2),
            child: Icon(leadingIcon, size: 20, color: Colors.blueGrey),
          ),
        SizedBox(
          width: 150,
          child: Text('$label :', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: valueWidget ??
                    Text(value ?? '-', style: const TextStyle(color: Colors.black87)),
              ),
              if (icon != null) icon,
            ],
          ),
        ),
      ],
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    final dt = DateTime.tryParse(dateStr);
    return dt != null ? DateFormat('d MMM y HH:mm').format(dt) : dateStr;
  }

  Widget _activeBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'ใช้งานอยู่' : 'ปิดใช้งาน',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
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
