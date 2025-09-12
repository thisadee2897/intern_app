import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_role_controllers.dart';
import 'package:project/screens/home/providers/controllers/get_workspace_role_by_workspace.dart';
import 'package:project/screens/home/providers/controllers/insert_or_update_workspace_role_controllers.dart';
import 'package:project/screens/home/providers/controllers/search_dialog_user_Controllers.dart';
import 'package:project/screens/home/providers/controllers/search_master_user_controllers.dart';

/// ✅ Dialog สำหรับจัดการ User ใน Workspace
class UserManagementDialog extends ConsumerStatefulWidget {
  final String workspaceId;

  const UserManagementDialog({Key? key, required this.workspaceId})
    : super(key: key);

  @override
  ConsumerState<UserManagementDialog> createState() =>
      _UserManagementDialogState();
}

class _UserManagementDialogState extends ConsumerState<UserManagementDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(getWorkspaceRoleByWorkspaceController.notifier)
          .fetch(widget.workspaceId);
    });
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
      builder:
          (context) => AlertDialog(
            title: const Text("ยืนยันการลบ"),
            content: Text("คุณแน่ใจว่าต้องการลบ ${user.name} หรือไม่?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ยกเลิก"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
                child: const Text("ลบ"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workspaceRolesState = ref.watch(
      getWorkspaceRoleByWorkspaceController,
    );

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Manage access',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _showAddUserDialog,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add people'),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search box
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),

              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Find a collaborator...",
                hintStyle: TextStyle(color: Color.fromARGB(255, 109, 109, 109)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 109, 109, 109),
                ),
                filled: true,

                fillColor: Color.fromARGB(255, 225, 224, 224),
                hoverColor: Color.fromARGB(255, 213, 213, 213), // ✅ สีตอน hover
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
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
                          color: Color.fromARGB(255, 138, 137, 137),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, i) {
                      final user = users[i]!;
                      return UserListItem(
                        user: user,
                        onDelete: () => _showDeleteConfirmationDialog(user),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("เกิดข้อผิดพลาด: $e")),
              ),
            ),
          ],
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
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: user.image != null && user.image!.isNotEmpty
              ? NetworkImage(user.image!)
              : null,
          child: user.image == null || user.image!.isEmpty
              ? const Icon(Icons.person, color: Colors.grey)
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
                  color: Colors.black87,
                ),
              ),
              Text(
                "${user.email ?? ''} • Collaborator",
                style: const TextStyle(
                  color: Color.fromARGB(255, 118, 117, 117),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 16),
          tooltip: 'delete user',
        ),
      ],
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

class _AddUserDialogState extends ConsumerState<AddUserDialog> {
  final TextEditingController _searchController = TextEditingController();
  Set<String> _selectedUserIds = {}; // เก็บ user ที่เลือกใน dialog

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(searchDialogUserController.notifier)
          .state = const AsyncValue.data([]);
      _selectedUserIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchDialogUserController);
    final workspaceRolesState = ref.watch(getWorkspaceRoleByWorkspaceController);

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add people',
            style: TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search box (ช่องค้นหา) สำหรับเพิ่ม user เข้า workspace
            TextField(
              controller: _searchController,
              onChanged:
                  (v) =>
                      ref.read(searchDialogUserController.notifier).search(v),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 167, 167, 167),
                ),
                hintText: 'Search by username, full name, or email',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 167, 167, 167),

                  fontSize: 16,
                ),
                filled: true,

                fillColor: Color.fromARGB(255, 225, 224, 224),
                hoverColor: Color.fromARGB(255, 213, 213, 213), // ✅ สีตอน hover
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 100),
              ),
            ),
            const SizedBox(height: 8),

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
                    children:
                        filteredUsers.map((user) {
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
                                color:
                                    isSelected
                                        ? const Color.fromARGB(
                                          255,
                                          209,
                                          221,
                                          250,
                                        ) // highlight สีเขียวถ้าเลือก
                                        : const Color.fromARGB(
                                          255,
                                          245,
                                          245,
                                          246,
                                        ),
                                borderRadius: BorderRadius.circular(8.0),
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
                                        ? const Icon(Icons.person, color: Colors.grey)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          user.email ?? '',
                                          style: const TextStyle(
                                            color: Color(0xFF6B7280),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
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
                    style: TextStyle(color: Color.fromARGB(255, 131, 130, 130)),
                  );
                }
              },
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  ),
              error:
                  (e, st) => Text(
                    'เกิดข้อผิดพลาด: ${e.toString()}',
                    style: const TextStyle(color: Colors.red),
                  ),
            ),
          ],
        ),
      ),

      // ปุ่มเพิ่ม user เข้า workspace
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color.fromARGB(255, 100, 100, 101)),
          ),
        ),
        ElevatedButton(
          onPressed:
              _selectedUserIds.isEmpty
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text("Add to repository"),
        ),
      ],
    );
  }
}
