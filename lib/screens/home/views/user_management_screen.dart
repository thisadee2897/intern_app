import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_role_controllers.dart';
import 'package:project/screens/home/providers/controllers/get_workspace_role_by_workspace.dart';
import 'package:project/screens/home/providers/controllers/insert_or_update_workspace_role_controllers.dart';
import 'package:project/screens/home/providers/controllers/search_dialog_user_Controllers.dart';
import 'package:project/screens/home/providers/controllers/search_master_user_controllers.dart';
import 'package:project/screens/auth/widgets/glass_container.dart';
import 'package:project/utils/extension/hex_color.dart';

/// ✅ Dialog สำหรับจัดการ User ใน Workspace
class UserManagementDialog extends ConsumerStatefulWidget {
  final String workspaceId;

  const UserManagementDialog({Key? key, required this.workspaceId})
    : super(key: key);

  @override
  ConsumerState<UserManagementDialog> createState() =>
      _UserManagementDialogState();
}

class _UserManagementDialogState extends ConsumerState<UserManagementDialog> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();

    Future.microtask(() {
      ref
          .read(getWorkspaceRoleByWorkspaceController.notifier)
          .fetch(widget.workspaceId);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AddUserDialog(workspaceId: widget.workspaceId),
    );
  }

  void _showDeleteConfirmationDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: FloatingCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "ยืนยันการลบ",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "คุณแน่ใจว่าต้องการลบ ${user.name} หรือไม่?",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: HexColor.fromHex('#002B77'), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    ),
                    child: const Text("ยกเลิก", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final userId = user.id!;
                      final userName = user.name;

                      final success = await ref
                          .read(deleteWorkspaceRoleController.notifier)
                          .delete(widget.workspaceId, userId);

                      if (success) {
                        await ref
                            .read(getWorkspaceRoleByWorkspaceController.notifier)
                            .fetch(widget.workspaceId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("ลบ $userName สำเร็จ")),
                        );
                      } else {
                        ref
                            .read(searchMasterUserController.notifier)
                            .restoreUser(user);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("ลบไม่สำเร็จ กรุณาลองใหม่")),
                        );
                      }

                      Navigator.pop(context);
                    },
                    child: const Text("ลบ", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workspaceRolesState = ref.watch(
      getWorkspaceRoleByWorkspaceController,
    );

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: FloatingCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.people_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Manage access',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: _showAddUserDialog,
                            style: FilledButton.styleFrom(
                              backgroundColor: HexColor.fromHex('#003B99'),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.person_add, size: 16),
                            label: const Text('Add people'),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white70),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search box
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Find a collaborator...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white54,
                      ),
                      filled: true,
                      fillColor: HexColor.fromHex('#001B4B'),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF667eea)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User list
                  SizedBox(
                    height: 400,
                    child: workspaceRolesState.when(
                      data: (roles) {
                        final keyword = _searchController.text.trim().toLowerCase();
                        final users =
                            roles
                                .map((role) => role.masterUser)
                                .where(
                                  (user) =>
                                      user != null &&
                                      (keyword.isEmpty ||
                                          user.name?.toLowerCase().contains(
                                                keyword,
                                              ) ==
                                              true ||
                                          user.email?.toLowerCase().contains(
                                                keyword,
                                              ) ==
                                              true),
                                )
                                .toList();

                        if (users.isEmpty) {
                          return const Center(
                            child: Text(
                              "ไม่พบผู้ใช้",
                              style: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: users.length,
                          separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.2)),
                          itemBuilder: (context, i) {
                            final user = users[i]!;
                            return UserListItem(
                              user: user,
                              onDelete: () => _showDeleteConfirmationDialog(user),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF667eea))),
                      error: (e, _) => Center(child: Text("เกิดข้อผิดพลาด: $e", style: const TextStyle(color: Colors.white))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// User list item
class UserListItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback onDelete;

  const UserListItem({super.key, required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: user.image != null && user.image!.isNotEmpty
                ? NetworkImage(user.image!)
                : null,
            child: user.image == null || user.image!.isEmpty
                ? const Icon(Icons.person, color: Colors.white70)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${user.email ?? ''} • Collaborator",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 16),
            tooltip: 'delete user',
          ),
        ],
      ),
    );
  }
}

// Dialog สำหรับเพิ่ม User เข้า Workspace
class AddUserDialog extends ConsumerStatefulWidget {
  final String workspaceId;
  const AddUserDialog({super.key, required this.workspaceId});

  @override
  ConsumerState<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends ConsumerState<AddUserDialog> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  Set<String> _selectedUserIds = {}; // เก็บ user ที่เลือกใน dialog
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(searchDialogUserController.notifier)
          .state = const AsyncValue.data([]);
      _selectedUserIds.clear();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchDialogUserController);
    final workspaceRolesState = ref.watch(getWorkspaceRoleByWorkspaceController);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: FloatingCard(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Add people',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search box
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => ref.read(searchDialogUserController.notifier).search(v),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),
                        hintText: 'Search by username, full name, or email',
                        hintStyle: const TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: HexColor.fromHex('#001B4B'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF667eea)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search result
                    searchState.when(
                      data: (users) {
                        if (_searchController.text.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        
                        // กรอง email ที่มีอยู่แล้วใน workspace ออก
                        final existingEmails = workspaceRolesState.when(
                          data: (roles) => roles
                              .map((role) => role.masterUser?.email)
                              .where((email) => email != null && email.isNotEmpty)
                              .toSet(),
                          loading: () => <String>{},
                          error: (_, __) => <String>{},
                        );
                        
                        final filteredUsers = users.where((user) => 
                          user.email == null || 
                          user.email!.isEmpty || 
                          !existingEmails.contains(user.email)
                        ).toList();
                        
                        if (filteredUsers.isNotEmpty) {
                          return Column(
                            children: filteredUsers.map((user) {
                              final isSelected = _selectedUserIds.contains(user.id);
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedUserIds.remove(user.id);
                                    } else {
                                      _selectedUserIds.add(user.id!);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color.fromARGB(255, 103, 126, 234).withOpacity(0.3)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSelected
                                        ? Border.all(color: const Color(0xFF667eea), width: 2)
                                        : null,
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: user.image != null && user.image!.isNotEmpty
                                            ? NetworkImage(user.image!)
                                            : null,
                                        radius: 20,
                                        child: user.image == null || user.image!.isEmpty
                                            ? const Icon(Icons.person, color: Colors.white70)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.name ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              user.email ?? '',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF667eea),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return const Text(
                            "ไม่พบผู้ใช้",
                            style: TextStyle(color: Colors.white54),
                          );
                        }
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: Color(0xFF667eea)),
                      ),
                      error: (e, st) => Text(
                        'เกิดข้อผิดพลาด: ${e.toString()}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: HexColor.fromHex('#002B77'), width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _selectedUserIds.isEmpty
                              ? null
                              : () async {
                                  bool allSuccess = true;

                                  for (final userId in _selectedUserIds) {
                                    final body = {
                                      "master_workspace_role_id": "0",
                                      "workspace_id": widget.workspaceId,
                                      "user_id": userId,
                                      "can_create_category": true,
                                      "can_create_project": true,
                                      "can_create_sprint": true,
                                      "can_create_task": true,
                                    };
                                    print("API body: $body"); // Debug print

                                    final success = await ref
                                        .read(insertOrUpdateWorkspaceRoleController.notifier)
                                        .saveRole(body);
                                    print("Success: $success"); // Debug print
                                    if (!success) allSuccess = false;
                                  }

                                  Navigator.of(context).pop();

                                  // แยกกรณี เลือก 1 คน กับ หลายคน
                                  if (_selectedUserIds.length == 1) {
                                    if (allSuccess) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("เพิ่มผู้ใช้สำเร็จ")),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("เพิ่มผู้ใช้ไม่สำเร็จ")),
                                      );
                                    }
                                  } else {
                                    if (allSuccess) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("เพิ่มผู้ใช้ทั้งหมดสำเร็จ"),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("บางผู้ใช้เพิ่มไม่สำเร็จ"),
                                        ),
                                      );
                                    }
                                  }

                                  await ref
                                      .read(getWorkspaceRoleByWorkspaceController.notifier)
                                      .fetch(widget.workspaceId);
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: _selectedUserIds.isEmpty 
                                ? Colors.grey 
                                : HexColor.fromHex('#003B99'),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          ),
                          child: const Text("Add to repository"),
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
    );
  }
}
