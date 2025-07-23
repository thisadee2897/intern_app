import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_controllers.dart';
import 'package:project/screens/home/views/insert_update_workspace_screen.dart';

class WorkspaceCard extends ConsumerStatefulWidget {
  final WorkspaceModel workspace;
  final VoidCallback? onWorkspaceChanged;
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
    final users = widget.workspace.users ?? [];

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 300,
        height: 180,
        margin: const EdgeInsets.all(4), // Card มีระยะห่างเท่าๆกันทุกด้าน
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isHovered
                    ? const Color.fromARGB(255, 159, 168, 218)
                    : Colors.grey.shade300,
            width: 3,
          ),
          boxShadow:
              isHovered
                  ? [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 8),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 8),
                    ),
                  ],
          gradient:
              isHovered
                  ? LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 220, 224, 249),
                      const Color.fromARGB(255, 185, 192, 243),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color:
              isHovered
                  ? null
                  : const Color.fromARGB(175, 33, 39, 123), // พื้นหลังของ Card
        ),
        child: Stack(
          children: [
            //  ไอคอนตกแต่ง
            Positioned(
              top: 8,
              left: 8,
              child: Icon(
                Icons.dashboard_customize_rounded,
                color: const Color.fromARGB(184, 188, 202, 235),
                size: 35,
              ),
            ),
            // ปุ่มเมนู ⋮ มุมบนขวา
            Positioned(
              top: 0,
              right: 8,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color:
                      isHovered
                          ? const Color.fromARGB(160, 48, 63, 159)
                          : const Color.fromARGB(184, 188, 202, 235),
                ),
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
                    if (result == true) widget.onWorkspaceChanged?.call();
                  } else if (value == 'delete') {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("ยืนยันการลบ"),
                            content: const Text(
                              "คุณแน่ใจหรือไม่ว่าต้องการลบ Workspace นี้?",
                            ),
                            backgroundColor: Colors.white,
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
                        widget.onWorkspaceChanged?.call();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Delete Workspace เรียบร้อย'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('delete Workspace ไม่สำเร็จ: $e'),
                          ),
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
                            Icon(Icons.edit, size: 15),
                            SizedBox(width: 2),
                            Text('edit Workspace'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 15),
                            SizedBox(width: 2),
                            Text('delete Workspace'),
                          ],
                        ),
                      ),
                    ],
              ),
            ),

            // ชื่อ Workspace ตรงกลาง
            Center(
              child: Text(
                widget.workspace.name ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 242, 242, 244),
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.indigo.shade100.withOpacity(0.7),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // สมาชิกหลายคน (avatars) มุมล่างซ้าย
            if (users.isNotEmpty)
              Positioned(
                bottom: 12,
                left: 12,
                child: Row(
                  children: [
                    ...users
                        .take(4)
                        .map(
                          (user) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child:
                                  user.image != null && user.image!.isNotEmpty
                                      ? CircleAvatar(
                                        radius: 14,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                              user.image!,
                                            ),
                                      )
                                      : const CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.indigo,
                                        child: Icon(
                                          Icons.person,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                    if (users.length > 4)
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.indigo.shade200,
                        child: Text(
                          '+${users.length - 4}',
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


