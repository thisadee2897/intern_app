import 'package:flutter/material.dart';
import 'package:project/models/workspace_model.dart';

class WorkspaceCard extends StatefulWidget {
  final WorkspaceModel workspace;

  const WorkspaceCard({super.key, required this.workspace});

  @override
  State<WorkspaceCard> createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends State<WorkspaceCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.workspace.users != null && widget.workspace.users!.isNotEmpty
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
            color: isHovered
                ? const Color.fromARGB(162, 114, 133, 227) // ฟ้าสวยเวลา Hover
                : const Color.fromARGB(189, 220, 227, 230), // โทนเทาฟ้าอ่อนปกติ
            width: 5,
          ),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: const Color.fromARGB(255, 109, 110, 110).withOpacity(0.3),
                    blurRadius: 11,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
          image: user != null && user.image != null
              ? DecorationImage(
                  image: NetworkImage(user.image!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                )
              : null,
          color: const Color.fromARGB(65, 173, 215, 240), // พื้นหลังกรณีไม่มีภาพ
        ),
        child: Stack(
          children: [
            //  Tag มุมบนซ้าย
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
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

            //  ชื่อ Workspace ตรงกลาง
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

            //  Avatar + ID มุมล่างซ้าย
            Positioned(
              bottom: 12,
              left: 12,
              child: Row(
                children: [
                  if (user != null && user.image != null)
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(user.image!),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    'ID: ${widget.workspace.id ?? "-"}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
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
