import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_controllers.dart';
import 'package:project/screens/home/views/insert_update_workspace_screen.dart';

class WorkspaceCard extends ConsumerStatefulWidget {
  final WorkspaceModel workspace;
  final VoidCallback?
  onWorkspaceChanged; // สำหรับ refresh list หลัง update/delete

  // เพิ่มนี้เข้ามา
  final Future<void> Function(String id)? onDeleteWorkspace;

  const WorkspaceCard({
    super.key,
    required this.workspace,
    this.onWorkspaceChanged,
    this.onDeleteWorkspace,
  });

  @override
  ConsumerState<WorkspaceCard> createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends ConsumerState<WorkspaceCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final user =
        widget.workspace.users != null && widget.workspace.users!.isNotEmpty
            ? widget.workspace.users![0]
            : null;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 240,
        height: 140,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isHovered
                    ? const Color.fromARGB(162, 114, 133, 227)
                    : const Color.fromARGB(189, 220, 227, 230),
            width: 5,
          ),
          boxShadow:
              isHovered
                  ? [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        109,
                        110,
                        110,
                      ).withOpacity(0.3),
                      blurRadius: 11,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : [],
          image:
              user != null && user.image != null
                  ? DecorationImage(
                    image: NetworkImage(user.image!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  )
                  : null,
          color: const Color.fromARGB(65, 173, 215, 240),
        ),
        child: Stack(
          children: [
            // 🔖 Tag มุมบนซ้าย
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Template',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),

            // ⋮ ปุ่มเมนู update / delete มุมขวาบน
            Positioned(
              top: 4,
              right: 4,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) async {
                  if (value == 'update') {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => InsertUpdateWorkspaceScreen(
                              workspace: widget.workspace,
                            ),
                      ),
                    );
                    if (result == true) {
                      widget.onWorkspaceChanged?.call();
                    }
                  } else if (value == 'delete') {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("ยืนยันการลบ"),
                            content: const Text(
                              "คุณแน่ใจหรือไม่ว่าต้องการลบ Workspace นี้?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("ยกเลิก"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("ลบ"),
                              ),
                            ],
                          ),
                    );

                    if (confirmed == true) {
                      try {
                        await ref
                            .read(deleteWorkspaceControllerProvider.notifier)
                            .deleteWorkspace(id: widget.workspace.id!);
                        widget.onWorkspaceChanged?.call(); // รีโหลด list
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ลบ Workspace เรียบร้อย'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ลบ Workspace ไม่สำเร็จ: $e')),
                        );
                      }
                    }
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'update',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('แก้ไข Workspace'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18),
                            SizedBox(width: 8),
                            Text('ลบ Workspace'),
                          ],
                        ),
                      ),
                    ],
              ),
            ),

            // 📛 ชื่อ workspace ตรงกลาง
            Center(
              child: Text(
                widget.workspace.name ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🧑 Avatar มุมล่างซ้าย
            Positioned(
              bottom: 12,
              left: 12,
              child: CircleAvatar(
                radius: 14,
                child: CachedNetworkImage(
                  imageBuilder:
                      (context, imageProvider) => CircleAvatar(
                        radius: 14,
                        backgroundImage: imageProvider,
                      ),
                  imageUrl: user?.image ?? '',
                  errorWidget:
                      (context, url, error) => const Icon(
                        Icons.person,
                        size: 28,
                        color: Colors.blue,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

