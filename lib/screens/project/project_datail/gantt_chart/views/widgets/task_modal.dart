// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../models/gantt_models.dart';
// import '../../utils/date_helpers.dart';
// import '../../providers/gantt_data_provider.dart';

// class TaskModal extends ConsumerStatefulWidget {
//   final Task? task;
//   final VoidCallback onClose;

//   const TaskModal({
//     super.key,
//     required this.task,
//     required this.onClose,
//   });

//   @override
//   ConsumerState<TaskModal> createState() => _TaskModalState();
// }

// class _TaskModalState extends ConsumerState<TaskModal> {
//   final TextEditingController _commentController = TextEditingController();

//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }

//   void _handleAddComment() {
//     if (widget.task != null && _commentController.text.trim().isNotEmpty) {
//       ref.read(ganttDataProvider.notifier).addCommentToTask(
//         widget.task!.id,
//         _commentController.text.trim(),
//       );
//       _commentController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.task == null) return const SizedBox.shrink();

//     // Get updated task data from provider
//     final ganttData = ref.watch(ganttDataProvider);
//     final currentTask = ganttData.tasks.firstWhere(
//       (t) => t.id == widget.task!.id,
//       orElse: () => widget.task!,
//     );

//     return GestureDetector(
//       onTap: widget.onClose,
//       child: Container(
//         color: Colors.black.withOpacity(0.6),
//         child: Center(
//           child: GestureDetector(
//             onTap: () {}, // Prevent closing when tapping inside modal
//             child: Container(
//               margin: const EdgeInsets.all(16),
//               constraints: const BoxConstraints(maxWidth: 500),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1F2937),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Header
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: const BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(color: Color(0xFF374151)),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             currentTask.name,
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: widget.onClose,
//                           icon: const Icon(
//                             Icons.close,
//                             color: Color(0xFF9CA3AF),
//                           ),
//                           hoverColor: Colors.white.withOpacity(0.1),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Task Details
//                   Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.calendar_today,
//                               size: 16,
//                               color: Color(0xFF9CA3AF),
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'Start Date: ',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF9CA3AF),
//                               ),
//                             ),
//                             Text(
//                               DateHelpers.format(currentTask.start, 'yyyy-MM-dd'),
//                               style: const TextStyle(color: Color(0xFFE5E7EB)),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.event,
//                               size: 16,
//                               color: Color(0xFF9CA3AF),
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'End Date: ',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF9CA3AF),
//                               ),
//                             ),
//                             Text(
//                               DateHelpers.format(currentTask.end, 'yyyy-MM-dd'),
//                               style: const TextStyle(color: Color(0xFFE5E7EB)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Comments Section
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Comments',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           constraints: const BoxConstraints(maxHeight: 240),
//                           child: SingleChildScrollView(
//                             child: currentTask.comments.isNotEmpty
//                                 ? Column(
//                                     children: currentTask.comments.map((comment) {
//                                       return Container(
//                                         margin: const EdgeInsets.only(bottom: 16),
//                                         padding: const EdgeInsets.all(16),
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xFF374151),
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               comment.text,
//                                               style: const TextStyle(
//                                                 color: Color(0xFFD1D5DB),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Align(
//                                               alignment: Alignment.centerRight,
//                                               child: Text(
//                                                 DateHelpers.format(comment.createdAt, 'yyyy-MM-dd HH:mm'),
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color: Color(0xFF6B7280),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }).toList(),
//                                   )
//                                 : const Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 32),
//                                     child: Center(
//                                       child: Text(
//                                         'No comments yet.',
//                                         style: TextStyle(
//                                           color: Color(0xFF6B7280),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Add Comment Section
//                   Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Add a Comment',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         TextField(
//                           controller: _commentController,
//                           maxLines: 3,
//                           style: const TextStyle(color: Colors.white),
//                           decoration: InputDecoration(
//                             hintText: 'Type your comment here...',
//                             hintStyle: const TextStyle(color: Color(0xFF6B7280)),
//                             filled: true,
//                             fillColor: const Color(0xFF374151),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(color: Color(0xFF4B5563)),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: _handleAddComment,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF3B82F6),
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text(
//                               'Add Comment',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
