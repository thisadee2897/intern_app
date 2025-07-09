import 'package:flutter/material.dart';
import 'package:project/models/sprint_model.dart';

class SprintListItem extends StatefulWidget {
  final SprintModel sprint; // ข้อมูล sprint
  final VoidCallback onEdit; // ฟังก์ชันแก้ไข

  const SprintListItem({
    super.key,
    required this.sprint,
    required this.onEdit,
  });

  @override
  State<SprintListItem> createState() => _SprintListItemState();
}

class _SprintListItemState extends State<SprintListItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isHovered
        ? const Color.fromARGB(214, 68, 143, 180) // สีธีมตอน hover
        : const Color.fromARGB(255, 201, 202, 202); // สีปกติ

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(widget.sprint.name ?? 'Unnamed Sprint'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Goal: ${widget.sprint.goal ?? "-"}'),
              Text('Duration: ${widget.sprint.duration ?? "-"} days'),
              Text('Completed: ${widget.sprint.completed == true ? "Yes" : "No"}'),
              Text('Active: ${widget.sprint.active == true ? "Yes" : "No"}'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit,
            size: 20, color: Color.fromARGB(212, 106, 167, 211)),
            onPressed: widget.onEdit,
          ),
        ),
      ),
    );
  }
}
