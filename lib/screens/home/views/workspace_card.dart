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
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isHovered
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
                      : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          gradient:
              isHovered
                  ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      Theme.of(context).colorScheme.primary.withOpacity(0.25),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isHovered ? null :  const Color.fromARGB(255, 245, 246, 247),
        ),

        child: Stack(
          children: [
            // ไอคอนตกแต่งแบบไล่สี
            Positioned(
              top: 8,
              left: 8,
              child: ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 2, 27, 84),
                        const Color.fromARGB(255, 58, 84, 231),
                        const Color.fromARGB(255, 205, 136, 159),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                blendMode: BlendMode.srcIn,
                child: const Icon(Icons.dashboard_customize_rounded, size: 50),
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
                          ? const Color.fromARGB(159, 14, 23, 78)
                          : const Color.fromARGB(184, 82, 107, 164),
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
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 2),
                            Text('edit workspace'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16),
                            SizedBox(width: 2),
                            Text('delete workspace'),
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
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,

                  shadows: [
                    Shadow(
                      blurRadius: 1,
                      color: Colors.indigo.shade100.withOpacity(0.5),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // สมาชิกหลายคน (avatars) มุมล่างซ้าย
            if (users.isNotEmpty)
              Positioned(
                bottom: 10,
                left: 10,
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
                                        radius: 12,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                              user.image!,
                                            ),
                                      )
                                      : const CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.indigo,
                                        child: Icon(
                                          Icons.person,
                                          size: 14,
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
