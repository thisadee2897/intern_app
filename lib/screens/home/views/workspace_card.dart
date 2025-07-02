import 'package:flutter/material.dart';
import 'package:project/models/workspace_model.dart';

class WorkspaceCard extends StatelessWidget {
  final WorkspaceModel workspace;

  const WorkspaceCard({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    final user = workspace.users != null && workspace.users!.isNotEmpty ? workspace.users![0] : null;

    return Container(
      width: 200,
      height: 120,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        image: user != null && user.image != null
            ? DecorationImage(
                image: NetworkImage(user.image!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: Stack(
        children: [
          // Tag Template
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(8, 52, 52, 52).withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Template',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w100, color: Colors.white),
              ),
            ),
          ),

          // ชื่อ workspace ตรงกลาง
          Center(
            child: Text(
              workspace.name ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Avatar + ID มุมล่างซ้าย
          Positioned(
            bottom: 8,
            left: 8,
            child: Row(
              children: [
                if (user != null && user.image != null)
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(user.image!),
                  ),
                const SizedBox(width: 6),
                Text(
                  'ID: ${workspace.id ?? "-"}',
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
    );
  }
}
